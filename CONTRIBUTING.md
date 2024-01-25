# Contributing

## How to Contribute

This is an open source project, and we appreciate your help!

Each source file must include this license header:

```
/*
 * (c) Copyright IBM Corp. 2024
 */
```

Furthermore you must include a sign-off statement in the commit message.

> Signed-off-by: John Doe <john.doe@example.com>

### Please note that in the case of the below-mentioned scenarios, follow the specified steps:
- **Proposing New Features**: Vist the ideas portal for [Cloud Management and AIOps](https://automation-management.ideas.ibm.com/?project=INSTANA) and post your idea to get feedback from IBM. This is to avoid you wasting your valuable time working on a feature that the project developers are not interested in accepting into the code base.
- **Raising a Bug**: Please visit [IBM Support](https://www.ibm.com/mysupport/s/?language=en_US) and open a case to get help from our experts.
- **Merge Approval**: The codeowners use LGTM (Looks Good To Me) in comments on the code review to indicate acceptance. A change requires LGTMs from two of the members. Request review from @instana/eng-eum for approvals.


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
3. `rm -rf $PROJECT/InstanaExample/node_modules/@instana/react-native-agent/InstanaExample`
4. `cd $PROJECT/InstanaExample/android && ./gradlew clean --refresh-dependencies`
5. `cd $PROJECT/InstanaExample && npx react-native run-android`

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
