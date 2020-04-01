# react-native-instana-eum

## Getting started

`$ npm install react-native-instana-eum --save`

### Mostly automatic installation

`$ react-native link react-native-instana-eum`

## Getting started
```javascript
import InstanaEum from 'react-native-instana-eum';
```

### Warning

We recommend adding `http://localhost:8081` to the ignored URLs list to avoid the Agent from tracing communication with the Metro bundler:

```javascript
Instana.setIgnoreURLsByRegex(["http:\/\/localhost:8081.*"]);
```

### Android

You will need to add these in order to support automatic tracking of network requests in Android:

// TODO

## Running the example Android app

The first time:
1. set up your RN environment: https://reactnative.dev/docs/getting-started
2. clone project to $PROJECT
3. cd $PROJECT &&  yarn install
4. cd $PROJECT/android && ./gradlew build
5. cd $PROJECT/InstanaExample && yarn install
6. in a separate terminal: cd $PROJECT/InstanaExample && npx react-native start
7. cd $PROJECT/InstanaExample && npx react-native run-android


Every time you change the wrapper:
1. cd $PROJECT/android && ./gradlew build
2. cd $PROJECT/InstanaExample && yarn install --check-files
3. cd $PROJECT/InstanaExample/android && android/gradlew clean --refresh-dependencies
4. cd $PROJECT/InstanaExample && npx react-native run-android

## Warnings

### fetch(url)

In your Android module-level gradle file (usually `app/gradle.build`):
```groovy
dependencies {
    implementation "com.squareup.okhttp3:okhttp:4.3.1"
    implementation "com.squareup.okhttp3:okhttp-urlconnection:4.3.1"
}
```
It otherwise crashed. Apparently same issue as described in: https://github.com/facebook/react-native/issues/27250
