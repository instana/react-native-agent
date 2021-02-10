# Contributing

## How to Contribute

This is an open source project, and we appreciate your help!

In order to clarify the intellectual property license granted with contributions from any person or entity, a Contributor License Agreement ("CLA") must be on file that has been signed by each contributor, indicating agreement to the license terms below. This license is for your protection as a contributor as well as the protection of Instana and its customers; it does not change your rights to use your own contributions for any other purpose.

Please print, fill out, and sign the [contributor license agreement](https://github.com/instana/nodejs-sensor/raw/main/misc/instana-nodejs-cla-individual.pdf). Once completed, please scan the document as a PDF file and email to the following email address: ben@instana.com.

Thank you for your interest in the Instana React Native project!

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
