package com.instana.rn;

import android.app.Application;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
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

    private static final String E_SESSIONID_ERROR = "Tried to get SessionID before it being set";
    @ReactMethod
    public void getSessionID(Promise promise) {
        String sessionId = Instana.getSessionId();
        if (sessionId != null) {
            promise.resolve(sessionId);
        } else {
            promise.reject(E_SESSIONID_ERROR);
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
}
