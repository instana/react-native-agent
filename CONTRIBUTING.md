# Contributing

## Working on the RN wrapper for Android

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

## Working on the RN wrapper for iOS
### Check out the wrapper project

1. `git clone git@github.com:instana/instana-agent-react-native.git $PROJECT`
2. `cd $PROJECT && yarn install`
3. `cd $PROJECT/InstanaExample && yarn install`
4. `cd $PROJECT/InstanaExample/ios && pod install`
5. `cd $PROJECT/InstanaExample && npx react-native run-ios`

### Everytime you change the wrapper:

1. `cd $PROJECT/InstanaExample && yarn install --check-files`
2. `cd $PROJECT/InstanaExample && npx react-native run-ios`

### Everytime you update the sub dependencies (CocoaPods)

1. `cd $PROJECT/InstanaExample && yarn install --check-files`
2. `cd $PROJECT/InstanaExample/ios && pod install`
3. `cd $PROJECT/InstanaExample && npx react-native run-ios`
