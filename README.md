# Examples for Sendbird Calls
![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/language-Swift-orange.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/sendbird/quickstart-calls-ios/blob/develop/LICENSE.md)

## Introduction

Sendbird Calls SDK for iOS is used to initialize, configure, and build voice and video calling functionality into your iOS client app. 
In this repository, you will find multiple sample apps that implement various features of the Calls SDK into an iOS app.

In the `SendBirdCallsExample` Xcode Workspace, you will find multiple Xcode Projects that each provide quick implementation of a feature in Calls SDK.

> Find out more about Sendbird Calls for iOS on [Calls for iOS doc](https://sendbird.com/docs/calls/v1/ios/getting-started/about-calls-sdk). If you need any help in resolving any issues or have questions, visit [our community](https://community.sendbird.com).

<br />

### Before getting started

To run the example apps, you must install `SendBirdCalls` sdk by running the following command on your terminal window.
```bash
$ pod install
```

> For more information about requirements, refer to the [Calls QuickStart repository](https://github.com/sendbird/quickstart-calls-ios#before-getting-started).

### Receiving a DirectCall
In order to receive an incoming DirectCall, you must implement either Remote Notifications or VoIP Notifications.

Examples in this repository use basic Remote Notifications to receive an incoming call. For a DirectCall example app using VoIP Notifications, please refer to our [QuickStart sample](https://github.com/sendbird/quickstart-calls-ios).


## Samples

### [BaseSample](https://github.com/sendbird/examples-calls-ios/tree/main/BaseSample)
`BaseSample` project contains simple implementation of making and receiving a DirectCall. 

### [ScreenCapture Example](https://github.com/sendbird/examples-calls-ios/tree/main/ScreenCapture)
`ScreenCapture` project contains implementation of capturing local and remote video view while making a DirectCall. 

### [ScreenRecording Example](https://github.com/sendbird/examples-calls-ios/tree/main/ScreenRecord)
`ScreenRecording` project contains implementation of recording local and remote user's video and audio while making a DirectCall. 

### [ScreenShare Example](https://github.com/sendbird/examples-calls-ios/tree/main/ScreenShare)
`ScreenShare` project contains implementation of sharing local screen with the remote user while making a DirectCall. This sample uses Apple's `ReplayKit` to capture and share the app's screen.  

### [LocalViewControl Example](https://github.com/sendbird/examples-calls-ios/tree/main/LocalViewControl)
`LocalViewControl` project contains implementation of switching camera device and mirroring local videoView while making a DirectCall.   

### [Sound Effect Example](https://github.com/sendbird/examples-calls-ios/tree/main/SoundEffect)
`SoundEffect` project contains implementation of configuring different sound effects for Direct Call. 

### [Media Control Example](https://github.com/sendbird/examples-calls-ios/tree/main/MediaControl)
`MediaControl` project contains implementation of toggling audio / video status while making a DirectCall. 

### [Call History Example](https://github.com/sendbird/examples-calls-ios/tree/main/CallHistory)
`CallHistory` project contains implementation of querying and displaying call history using DirectCallLogListQuery. 

### [VoIP Notification Example](https://github.com/sendbird/examples-calls-ios/tree/main/VoIPNotifications)
`VoIPNotifications` project contains implementation of integrating Apple's CallKit with SendBirdCalls.
