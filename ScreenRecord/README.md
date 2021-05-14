# Local Recording Example
This example shows how you can record local or remote user's video and audio while making a Direct Call. The recorded file will be saved on the user’s local file storage and users can transfer or process the file.

Only one ongoing recording session is allowed, which means that the current recording session must be stopped in order to start another recording. However, several sessions can be recorded throughout the call, thus multiple recording files created from one call.

> In this example, after recording is finished, the recorded file is saved to the app's document directory and can be replayed in `RecordingTableViewController`. 

For more information about local media recording, please take a look at [our documentation](https://sendbird.com/docs/calls/v1/ios/guides/key-functions#2-record-audio-and-video). 
