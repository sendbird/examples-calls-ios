# Media Control Example

In this project, you can discover how to toggle audio / video status for direct call.

```swift
/************************
CallViewController.swift
************************/
    @IBAction func didTapMic() {
        if call.isLocalAudioEnabled {
            call.muteMicrophone()
        } else {
            call.unmuteMicrophone()
        }
    }
    
    @IBAction func didTapVideo() {
        if call.isLocalVideoEnabled {
            call.stopVideo()
        } else {
            call.startVideo()
        }
    }
```

## Mute / Unmute microphone

### muteMicrophone
Mutes the audio of local user. Will trigger DirectCallDelegate.didRemoteAudioSettingsChange() delegate method of the remote user. If the remote user changes their audio settings, local user will be notified via same delegate method.

```swift
// mute my microphone
call.muteMicrophone();

// receives the event
class MyClass: DirectCallDelegate {
    ...
    func didRemoteAudioSettingsChange(_ call: DirectCall) {
        if (call.isRemoteAudioEnabled) {
            // The peer has been unmuted.
        } else {
            // The peer has been muted.
        }
    }
    ...
}
```

### unmuteMicrophone
Unmutes the audio of local user. Will trigger DirectCallDelegate.didRemoteAudioSettingsChange() delegate method of the remote user. If the remote user changes their audio settings, local user will be notified via same delegate method.

```swift
// unmute my microphone
call.unmuteMicrophone();

// receives the event
class MyClass: DirectCallDelegate {
    ...
    func didRemoteAudioSettingsChange(_ call: DirectCall) {
        if (call.isRemoteAudioEnabled) {
            // The peer has been unmuted.
        } else {
            // The peer has been muted.
        }
    }
    ...
}
```

## Stop / Start video

### stopVideo
Stops local video. If the callee changes video settings, the caller is notified via the DirectCallDelegate.didRemoteVideoSettingsChange() delegate.

```swift
// Stop my local video
call.stopVideo()

// receives the event
class MyClass: DirectCallDelegate {
    ...
    func didRemoteVideoSettingsChange(_ call: DirectCall) {
        if (call.isRemoteVideoEnabled) {
            // The peer has been unmuted.
        } else {
            // The peer has been muted.
        }
    }
    ...
}
```

### startVideo
Starts local video. If the callee changes video settings, the caller is notified via the DirectCallDelegate.didRemoteVideoSettingsChange() delegate.

```swift
// Start my local video
call.startVideo()

// receives the event
class MyClass: DirectCallDelegate {
    ...
    func didRemoteVideoSettingsChange(_ call: DirectCall) {
        if (call.isRemoteVideoEnabled) {
            // The peer has been unmuted.
        } else {
            // The peer has been muted.
        }
    }
    ...
}
```


## isLocalAudioEnabled
The audio status of the local user.

## isLocalVideoEnabled
The diplaying status of the local user.
