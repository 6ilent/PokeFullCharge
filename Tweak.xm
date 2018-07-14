//Needed to play audio
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

//Definitions for usage
#define kIdentifier @"com.6ilent.pokefullcharge"
#define kSettingsChangedNotification (CFStringRef)@"com.6ilent.pokefullcharge/ReloadPrefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.6ilent.pokefullcharge.plist"

//Variables from the preference fil
static BOOL enabled;
static BOOL lowenabled;
static NSInteger batPercent;
static NSInteger lowbatPercent;

//Creates the audio player
AVAudioPlayer *player;
AVAudioPlayer *lowplayer;

//Hooks the needed method
%hook UIDevice
  -(void)_setBatteryLevel:(float)arg1 {
    //Runs the original code
    %orig;

    //Creates a UIDevice object which is used to get the battery level and store it in 'batLeft'
    UIDevice *dev = [UIDevice currentDevice];
    float batLeft = [dev batteryLevel]*100;

    //Formats the string with the remaining battery so it can be used
    NSString *batString = [NSString stringWithFormat:@"%0.0f", batLeft];

    //Formats our preference integer into a string for comparison
    // //We have to cast our integer as a long because the compiler likes it like that
    NSString *batPercent_String = [NSString stringWithFormat:@"%ld", (long)batPercent];
    NSString *lowbatPercent_String = [NSString stringWithFormat:@"%ld", (long)lowbatPercent];

    //Sound player path variables
    NSString *soundFilePath;
    NSURL *soundFileURL;

    //Runs the code IF the tweak is ENABLED
    if (enabled) {
      //If its our percent value and hasn't played yet
      if ([batString isEqualToString:batPercent_String]) {
        // // YES: Play the healing sound
        if (player) {
          return;
        }

        //Grabs the sound file from the bundle path and makes the NSURL equal to it
        soundFilePath = @"/Library/MobileSubstrate/DynamicLibraries/com.6ilent.pokefullcharge.bundle/heal.mp3";
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];

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

    //The same as above but this time with the low health
    if (lowenabled) {
      if ([batString isEqualToString:lowbatPercent_String]) {
        if (player) {
          return;
        }

        soundFilePath = @"/Library/MobileSubstrate/DynamicLibraries/com.6ilent.pokefullcharge.bundle/lowhealth.mp3";
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];

        lowplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        lowplayer.numberOfLoops = 0;
        [lowplayer play];
      } else {
        if (lowplayer) {
          lowplayer = nil;
        }
      }
    }
}
%end

//Reloads the Preferences
static void reloadPrefs() {
  //Identifies our tweak
  CFPreferencesAppSynchronize((CFStringRef)kIdentifier);

  //Defines our dictionary and adds the values
  NSDictionary *prefs = nil;
  if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
    CFArrayRef keys = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

    if (keys != nil) {
      prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keys, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

      if (prefs == nil) {
        prefs = [NSDictionary dictionary];
      }
      CFRelease(keys);
    }
  } else {
    prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
  }

  //Assigns the values that are in the prefs Dictionary into our variables
  enabled = [prefs objectForKey:@"enabled"] ? [(NSNumber *)[prefs objectForKey:@"enabled"] boolValue] : false;
  batPercent = [prefs objectForKey:@"batPercent"] ? [[prefs objectForKey:@"batPercent"] integerValue] : 100;
  lowenabled = [prefs objectForKey:@"lowenabled"] ? [(NSNumber *)[prefs objectForKey:@"lowenabled"] boolValue] : false;
  lowbatPercent = [prefs objectForKey:@"lowbatPercent"] ? [[prefs objectForKey:@"lowbatPercent"] integerValue] : 20;
}

//The constructor of our tweak (What gets loaded before anything else, in a sense the "entry point" of our tweak)
// // Make sure it's at the end so everything gets loaded into memory first and then can construct
%ctor {
  reloadPrefs();
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
