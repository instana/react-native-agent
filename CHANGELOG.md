# Changelog

# 2.0.7
- Add support for SuspendReporting in Android Platform
- Upgrade iOSAgent to 1.8.7, android-agent to 6.1.0
- Android: Added queryTrackedDomainList feature to exclude parameters from url other than in this list
- iOS: Added queryTrackedDomainList feature to exclude parameters from url other than in this list
- Modifying Instana Type Declaration extending type of Native Modules

# 2.0.6
- Support Typescript projects

# 2.0.5
- CustomMetric field support in reportEvent method
- Upgrade iOSAgent to 1.6.9, android-agent to 6.0.14

# 2.0.4
- Fix gradle 8 issue for android platform

# 2.0.3
- Pass react-native-agent id and version down to iOSAgent and android-agent
- Upgrade iOSAgent version to 1.6.8, android-agent version to 6.0.12

# 2.0.2
- Integrate with android-agent 6.0.9:
- `Instana.captureHeaders`, `Instana.ignoreURLs`, `Instana.redactHTTPQuery` type updated to `Collections.synchronizedList`, to avoid concurrent update exceptions
- Change beacon id from 128 bit UUID to 64 bit hex string
- ASM 9 upgrade to support JAVA_17 with sealed classes

- Integrate with iOSAgent 1.6.7:
- Fix unit test cases that failed in command line execution or in Xcode 15
- Change beacon id from 128 bit UUID to 64 bit hex string

# 2.0.1
- Support user session id by upgrading iOSAgent to 1.6.5, android-agent to 6.0.7

# 2.0.0
- Update native Android agent to version 6.0.4

# 1.12.1
- Update native iOS agent to version 1.6.4 which fixed http response header capture issue

# 1.12.0
- Upgrade Gradle version to 6.7.1 to fix build issue
- Update yarn.lock to match with android-agent 5.2.4 & iOSAgent 1.5.2
- InstanaExample fixes and upgrade

# 1.11.0
- Update native Android agent to version 5.2.4

# 1.10.0
- Add feature to capture request/response headers
- Update native iOS agent to version 1.5.2
- Update native Android agent to version 5.2.3

# 1.9.0
- Add feature to redact query parameters
- Update native iOS agent to version 1.4.0
- Update native Android agent to version 5.1.0

# 1.8.1
- Update native iOS agent to version 1.3.1

# 1.8.0
- Support React Native 0.67.3
- Update native Android agent to version 5.0.3

# 1.7.0
- Update native iOS agent to version 1.3.0

# 1.6.2
- Update native iOS agent to version 1.2.4

## 1.6.1
- Bump native iOS agent to 1.2.2

## 1.6.0
- Update native iOS and Android Instana agents
- Introduce collectionEnabled flag to disable or enable the agent after the setup process

## 1.5.6
- Update native iOS Instana agent version to 1.1.18

## 1.5.5
- Update native iOS Instana agent version to 1.1.16

## 1.5.4
- Update native Android Instana agent version to 1.6.1

## 1.5.3
- Update native Android Instana agent version to 1.6.0

## 1.5.2
- Update native iOS Instana agent version to 1.1.15

## 1.5.1
- Update native Android Instana agent version to 1.5.6

## 1.5.0
- Add suport for React Native 0.64.1

## 1.4.5
- Update native iOS Instana agent version to 1.1.13

## 1.4.4
- Update native iOS Instana agent version to 1.1.12
- Update native Android Instana agent version to 1.5.5

## 1.4.3
- Update native iOS Instana agent version to 1.1.10

## 1.4.2
- Update native iOS Instana agent version to 1.1.8

## 1.4.1
- Fix bug which could prevent crash on Android when app was started while the device screen is off

## 1.4.0
- Update native iOS Instana agent version to 1.1.1

## 1.3.0
- Update native Android Instana agent version to 1.3.0

## 1.2.0
- Update native iOS Instana agent version to 1.1.0

## 1.1.0
- Update native iOS Instana agent version to 1.0.7
- Update native Android Instana agent version to 1.2.0
- Add the ability to report custom events

## 1.0.1
- Update native iOS Instana agent version to 1.0.6

## 1.0.0

- Initial release
