/*
 * (c) Copyright IBM Corp. 2021
 * (c) Copyright Instana Inc. and contributors 2021
 */

package com.instana.rn;

import android.app.Activity;
import android.app.Application;
import android.util.Log;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.Promise;
import com.instana.android.Instana;
import com.instana.android.CustomEvent;
import com.instana.android.core.InstanaConfig;

import javax.annotation.Nullable;

public class InstanaEumModule extends ReactContextBaseJavaModule implements LifecycleEventListener {

    private final ReactApplicationContext reactContext;
    private String key;
    private String reportingUrl;
    @Nullable private ReadableMap options;

    private static final String CUSTOMEVENT_START_TIME = "startTime";
    private static final String CUSTOMEVENT_DURATION = "duration";
    private static final String CUSTOMEVENT_VIEW_NAME = "viewName";
    private static final String CUSTOMEVENT_META = "meta";
    private static final String CUSTOMEVENT_BACKEND_TRACING_ID = "backendTracingId";
    private static final String SETUPOPTIONS_COLLECTION_ENABLED = "collectionEnabled";

    public InstanaEumModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "Instana";
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(CUSTOMEVENT_START_TIME, CUSTOMEVENT_START_TIME);
        constants.put(CUSTOMEVENT_DURATION, CUSTOMEVENT_DURATION);
        constants.put(CUSTOMEVENT_VIEW_NAME, CUSTOMEVENT_VIEW_NAME);
        constants.put(CUSTOMEVENT_META, CUSTOMEVENT_META);
        constants.put(CUSTOMEVENT_BACKEND_TRACING_ID, CUSTOMEVENT_BACKEND_TRACING_ID);
        constants.put(SETUPOPTIONS_COLLECTION_ENABLED, SETUPOPTIONS_COLLECTION_ENABLED);
        return constants;
    }

    @Override
    public void onHostResume() {
        if (Instana.getSessionId() == null && this.key != null && this.reportingUrl != null) {
            Activity activity = getCurrentActivity();
            if (activity != null) {
                Log.i("Instana", "Instana Android Agent successfully retried to set up");
                doSetup(activity.getApplication(), this.key, this.reportingUrl, this.options);
            } else {
                Log.e("Instana", "Instana Android Agent failed again trying to obtain an Activity. Instana Android Agent won't be set up");
            }
        }
        getReactApplicationContext().removeLifecycleEventListener(this);
    }

    @Override
    public void onHostPause() {}
  
    @Override
    public void onHostDestroy() {}

    @ReactMethod
    public void setup(String key, String reportingUrl, @Nullable ReadableMap options) {
        Activity activity = getCurrentActivity();
        if (activity != null) {
            doSetup(activity.getApplication(), key, reportingUrl, options);
        } else {
            Log.w("Instana", "No Activity available on setup() call. Instana Android Agent won't be set up now; will retry when an Activity becomes available");
            this.key = key;
            this.reportingUrl = reportingUrl;
            this.options = options;
            getReactApplicationContext().addLifecycleEventListener(this);
        }
    }

    private void doSetup(Application application, String key, String reportingUrl, @Nullable ReadableMap options) {
        InstanaConfig config = new InstanaConfig(key, reportingUrl);
        if (options != null) {
            if (options.hasKey(SETUPOPTIONS_COLLECTION_ENABLED)) {
                config.setCollectionEnabled((boolean) options.getBoolean(SETUPOPTIONS_COLLECTION_ENABLED));
            }
        }
        Instana.setup(application, config);
    }

    @ReactMethod
    public void setCollectionEnabled(Boolean enabled) {
        Instana.setCollectionEnabled(enabled);
    }

    @ReactMethod
    public void setView(String viewName) {
        Instana.setView(viewName);
    }

    @ReactMethod
    public void getSessionID(final Promise promise) {
        String sessionId = Instana.getSessionId();
        if (sessionId != null) {
            promise.resolve(sessionId);
        } else {
            promise.reject("Tried to get SessionID before it being set");
        }
    }

    @ReactMethod
    public void setUserID(String userID) {
        Instana.setUserId(userID);
    }

    @ReactMethod
    public void setUserName(String userName) {
        Instana.setUserName(userName);
    }

    @ReactMethod
    public void setUserEmail(String userEmail) {
        Instana.setUserEmail(userEmail);
    }

    @ReactMethod
    public void setMeta(String key, String value) {
        Instana.getMeta().put(key, value);
    }

    @ReactMethod
    public void setIgnoreURLsByRegex(ReadableArray regexArray, final Promise promise) {
        List<String> failures = new ArrayList<String>();
        for (int i = 0; i < regexArray.size(); i++) {
            String regexString = regexArray.getString(i);
            try {
                Pattern p = Pattern.compile(regexString);
                Instana.getIgnoreURLs().add(p);
            } catch (Exception e) {
                failures.add(String.format("Failed to add regex `%s`: `%s`", regexString, e.getMessage()));
            }
        }

        if (failures.size() == 0) {
            promise.resolve(true);
        } else {
            StringBuilder sb = new StringBuilder();
            for (String failure : failures) {
                sb.append(failure);
                sb.append(System.getProperty("line.separator"));
            }
            promise.reject(sb.toString());
        }
    }

    @ReactMethod
    public void setRedactHTTPQueryByRegex(ReadableArray regexArray, final Promise promise) {
        List<String> failures = new ArrayList<String>();
        for (int i = 0; i < regexArray.size(); i++) {
            String regexString = regexArray.getString(i);
            try {
                Pattern p = Pattern.compile(regexString);
                Instana.getRedactHTTPQuery().add(p);
            } catch (Exception e) {
                failures.add(String.format("Failed to add regex `%s`: `%s`", regexString, e.getMessage()));
            }
        }

        if (failures.size() == 0) {
            promise.resolve(true);
        } else {
            StringBuilder sb = new StringBuilder();
            for (String failure : failures) {
                sb.append(failure);
                sb.append(System.getProperty("line.separator"));
            }
            promise.reject(sb.toString());
        }
    }

    @ReactMethod
    public void reportEvent(String eventName, @Nullable ReadableMap options) {
        CustomEvent event = new CustomEvent(eventName);
        if (options != null) {
            if (options.hasKey(CUSTOMEVENT_START_TIME)) {
                event.setStartTime((long) options.getDouble(CUSTOMEVENT_START_TIME));
            }
            if (options.hasKey(CUSTOMEVENT_DURATION)) {
                event.setDuration((long) options.getDouble(CUSTOMEVENT_DURATION));
            }
            if (options.hasKey(CUSTOMEVENT_VIEW_NAME)) {
                event.setViewName(options.getString(CUSTOMEVENT_VIEW_NAME));
            }
            if (options.hasKey(CUSTOMEVENT_BACKEND_TRACING_ID)) {
                event.setBackendTracingID(options.getString(CUSTOMEVENT_BACKEND_TRACING_ID));
            }
            if (options.hasKey(CUSTOMEVENT_META)) {
                HashMap metaMap = new HashMap<String, String>();
                ReadableMap readableMap = options.getMap(CUSTOMEVENT_META);
                ReadableMapKeySetIterator keySetIterator = readableMap.keySetIterator();
                while (keySetIterator.hasNextKey()) {
                    String key = keySetIterator.nextKey();
                    metaMap.put(key, readableMap.getString(key));
                }
                event.setMeta(metaMap);
            }
        }
        Instana.reportEvent(event);
    }

}
