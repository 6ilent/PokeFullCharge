//Needed to play audio
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

//Creates the audio player
AVAudioPlayer *player;

//Hooks the needed method
%hook UIDevice
  -(void)_setBatteryLevel:(float)arg1 {
    //Runs the original code
    %orig;

    //Creates a UIDevice object which is used to get the battery level and store it in 'batLeft'
    UIDevice *dev = [UIDevice currentDevice];
    float batLeft = [dev batteryLevel]*100;

    //Formats the string with the remaining battery so it can be used by the alert
    NSString *batString = [NSString stringWithFormat:@"%0.0f", batLeft];

    //If its 100% and hasn't played yet
    if ([batString isEqualToString:@"100"]) {
      // // YES: Play the healing sound
      if (player) {
        return;
      }

      //Grabs the sound file from the bundle path and makes the NSURL equal to it
      NSString *soundFilePath = @"/Library/MobileSubstrate/DynamicLibraries/com.6ilent.pokefullcharge.bundle/heal.mp3";
      NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];

      //Makes the audio player object and plays the sound 0(actually 1) time(s)
      player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
      player.numberOfLoops = 0;
      [player play];
    } else {
      // // NO: set the value to no
      if (player) {
        player = nil;
      }
    }
}
%end