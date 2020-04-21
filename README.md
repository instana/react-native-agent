# Instana React Native Agent <a href="https://www.npmjs.com/package/@instana/react-native-agent"><img alt="npm (scoped)" src="https://img.shields.io/npm/v/instana/react-native-agent?color=0db4b33"></a>

## Getting started

### Link Instana React Native Agent to your project

```
$ npm install @instana/react-native-agent --save 
```

### Android

Android will require you to take 2 extra steps in order to support automatic tracing of network requests:

1. In your `/android/build.gradle` file:

```groovy
buildscript {
    dependencies {
        classpath 'com.instana:android-agent-plugin:1.1.2'
    }
}
```

2. In your `/android/app/build.gradle` file (at the top):

```groovy
apply plugin: 'com.android.application'
apply plugin: 'com.instana.android-agent-plugin'
```

### Known issues

#### fetch(url)

If your app uses `fetch` to complete network requests, you might find your app crashing on runtime whenever `fetch` is used. 

If you encounter this issue and until the upstream issue is solved ([here](https://github.com/facebook/react-native/issues/27250) and [here](https://github.com/facebook/react-native/issues/28425)), please apply the following workaround.

In your Android module-level gradle file (usually `app/gradle.build`):
```groovy
dependencies {
    implementation "com.squareup.okhttp3:okhttp:4.3.1"
    implementation "com.squareup.okhttp3:okhttp-urlconnection:4.3.1"
}
```

### iOS

Your project needs to contains at least one Swift file (it can be empty).

If you don't have any, please open your Xcode Project in `<YourReactNativeProject>/ios` and add an empty Swift file. Please also let Xcode create the Bridging Header for you.

## Usage

Please refer to our [React Native API documentation](https://docs.instana.io/products/mobile_app_monitoring/react_native_api/).

### Recommendation

We recommend adding `http://localhost:8081` to the ignored URLs list to prevent the Agent from tracing communication with the Metro bundler:

```javascript
Instana.setIgnoreURLsByRegex(["http:\/\/localhost:8081.*"]);
```

## Contributing

### Working on the RN wrapper for Android

The first time:
1. set up your RN environment: https://reactnative.dev/docs/getting-started
2. clone project to `$PROJECT`
3. `cd $PROJECT &&  yarn install`
4. `cd $PROJECT/android && ./gradlew build`
5. `cd $PROJECT/InstanaExample && yarn install`
6. `cd $PROJECT/InstanaExample && npx react-native run-android`

Every time you make change to the RN wrapper:
1. `cd $PROJECT/android && ./gradlew build`
2. `cd $PROJECT/InstanaExample && yarn install --check-files`
3. `cd $PROJECT/InstanaExample/android && android/gradlew clean --refresh-dependencies`
4. `cd $PROJECT/InstanaExample && npx react-native run-android`

### Working on the RN wrapper for iOS
##### Check out the wrapper project

1. `git clone git@github.com:instana/instana-agent-react-native.git $PROJECT`
2. `cd $PROJECT && yarn install`
3. `cd $PROJECT/InstanaExample && yarn install`
4. `cd $PROJECT/InstanaExample/ios && pod install`
5. `cd $PROJECT/InstanaExample && npx react-native run-ios`

##### Everytime you change the wrapper:

1. `cd $PROJECT/InstanaExample && yarn install --check-files`
2. `cd $PROJECT/InstanaExample && npx react-native run-ios`

##### Everytime you update the sub dependencies (CocoaPods)

1. `cd $PROJECT/InstanaExample && yarn install --check-files`
2. `cd $PROJECT/InstanaExample/ios && pod install`
3. `cd $PROJECT/InstanaExample && npx react-native run-ios`
