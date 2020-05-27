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
3. `cd $PROJECT/InstanaExample/android && ./gradlew clean --refresh-dependencies`
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

## Release Process

To make a release, you first need to ensure that the released version will either be a semver minor or patch release so that automatic updates are working for our users. Following that, the process is simple:

- Update `CHANGELOG.md` so that the unreleased section gets its version number. Commit and push this change.
- Run either `npm version minor` or `npm version patch`.
- Acquire an OTP token for 2fa of npmjs.com
- run `npm publish`
