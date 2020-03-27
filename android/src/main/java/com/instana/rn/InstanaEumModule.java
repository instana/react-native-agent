package com.instana.rn;

import android.app.Application;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.Promise;
import com.instana.android.Instana;
import com.instana.android.core.InstanaConfig;

public class InstanaEumModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public InstanaEumModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "Instana";
    }

    @ReactMethod
    public void setup(String reportingUrl, String key) {
        Application application = reactContext.getCurrentActivity().getApplication();
        InstanaConfig config = new InstanaConfig(reportingUrl, key);
        Instana.setup(application, config);
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
}
