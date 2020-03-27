# react-native-instana-eum

## Getting started

`$ npm install react-native-instana-eum --save`

### Mostly automatic installation

`$ react-native link react-native-instana-eum`

## Usage
```javascript
import InstanaEum from 'react-native-instana-eum';

// TODO: What to do with the module?
InstanaEum;
```

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
