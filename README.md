# @instana/react-native-agent

## Getting started

```
$ npm install --save @instana/react-native-agent
```

### Mostly automatic installation

```
react-native link @instana/react-native-agent
```

## Getting started
```javascript
import Instana from '@instana/react-native-agent';
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


## iOS
### Integrate into your ReactNative project
#### Things you have to do in your project 

1. Add at least one Swift file (can be empty)
Open the Xcode Project in <YourReactNativeProject>/ios and add an empty Swift file. Also let Xcode create the Bridging Header

### Work on the wrapper
#### Check out the wrapper project

1. git clone git@github.com:instana/instana-agent-react-native.git $PROJECT
2. cd $PROJECT && yarn install
3. cd $PROJECT/InstanaExample && yarn install
4. cd $PROJECT/InstanaExample/ios && pod install
5. cd $PROJECT/InstanaExample && npx react-native run-ios 

#### Everytime you change the wrapper:

1. cd $PROJECT/InstanaExample && yarn install --check-files
2. cd $PROJECT/InstanaExample && npx react-native run-ios

#### Everytime you update the sub dependencies (CocoaPods)

1. cd $PROJECT/InstanaExample && yarn install --check-files
2. cd $PROJECT/InstanaExample/ios && pod install
3. cd $PROJECT/InstanaExample && npx react-native run-ios


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
