# Sound Effect

In this project, you can discover how to enable sound effects for direct call.

```swift
/********************************
AppDelegate.SoundEffect.swift
********************************/

SendBirdCall.setDirectCallDialingSoundOnWhenSilentMode(isEnabled: true)

SendBirdCall.addDirectCallSound("Ringing.mp3", forType: .ringing)
SendBirdCall.addDirectCallSound("Dialing.mp3", forType: .dialing)
SendBirdCall.addDirectCallSound("ConnectionLost.mp3", forType: .reconnecting)
SendBirdCall.addDirectCallSound("ConnectionRestored.mp3", forType: .reconnected)
```
## setDirectCallDialingSoundOnWhenSilentMode(isEnabled:)

### Summary
Enables / disables dial sound used in DirectCall even when the device is in silent mode. Call this method right after addDirectCallSound(_:forType:).

### Declaration
```swift
static func setDirectCallDialingSoundOnWhenSilentMode(isEnabled: Bool)
```

### code snippet
```swift
SendBirdCall.addDirectCallSound("dialing.mp3", forType: .dialing)
SendBirdCall.setDirectCallDialingSoundOnWhenSilentMode(isEnabled: true) // Will play dial direct call sounds in silent mode
```

### Parameters
| Parameter | Descriptionc |
| --- | --- |
| isEnabled | If it is true, dial sound used in DirectCall will be played in silent mode. |


## addDirectCallSound(_:bundle:forType:)

### Summary
Adds sound used in DirectCall such as ringtone and some sound effects with its file name and bundle.

### Declaration
```swift
static func addDirectCallSound(_ name: String, bundle: Bundle = .main, forType type: SoundType)
```

### code snippet
```swift
SendBirdCall.addDirectCallSound("dialing.mp3", forType: .dialing)
```

### Parameters
| Parameter | Description |
| --- | --- |
| name | The name of your audio file. Please explicit its extension: “dialing.mp3” |
| bundle | The bundle object. The default is main bundle. |
| type | The type of sound. |

