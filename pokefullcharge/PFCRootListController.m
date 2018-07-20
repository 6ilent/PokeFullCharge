#include "PFCRootListController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

//Paths and such
#define kIdentifier @"com.6ilent.pokefullcharge"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.6ilent.pokefullcharge.plist"
#define kSettingsChangedNotification (CFStringRef)@"com.6ilent.pokefullcharge/ReloadPrefs"
#define prefsAppID CFSTR("com.6ilent.pokefullcharge")

//Variables for sound playing
static NSString *bundlePrefix = @"/Library/MobileSubstrate/DynamicLibraries/com.6ilent.pokefullcharge.bundle";
static AVAudioPlayer *player;
static AVAudioPlayer *lowplayer;
static NSString *soundFilePath = nil;
static NSURL *soundFileURL;
static NSInteger sound;
static NSInteger lowsound;

@implementation PFCRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

//Twitter action
- (void)openTwitter {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Zer0Entry"] options:[NSDictionary new] completionHandler:nil];
}

//Reddit action
- (void)openReddit {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://reddit.com/u/6ilent"] options:[NSDictionary new] completionHandler:nil];
}

//Paypal action
- (void)openPaypal {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/6ilent"] options:[NSDictionary new] completionHandler:nil];
}

//Github action
- (void)openGithub {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/6ilent/PokeFullCharge"] options:[NSDictionary new] completionHandler:nil];
}

//Plays the Health Up Sound
- (void)playSound {
	reloadPrefs();

	//Sets the sound paths sound
	if (sound == 0)
		soundFilePath = [NSString stringWithFormat:@"%@/heal.mp3", bundlePrefix];
	else if (sound == 1)
		soundFilePath = [NSString stringWithFormat:@"%@/lowhealth.mp3", bundlePrefix];
	else if (sound == 2)
		soundFilePath = [NSString stringWithFormat:@"%@/solidalert.mp3", bundlePrefix];
	else if (sound == 3)
		soundFilePath = [NSString stringWithFormat:@"%@/switch_bing.wav", bundlePrefix];
	else if (sound == 4)
		soundFilePath = [NSString stringWithFormat:@"%@/switch_enter.wav", bundlePrefix];
	else if (sound == 5)
		soundFilePath = [NSString stringWithFormat:@"%@/switch_user.wav", bundlePrefix];

	//Grabs the sound file from the bundle path and makes the NSURL equal to it
	soundFileURL = [NSURL fileURLWithPath:soundFilePath];

	//Makes the audio player object and plays the sound 0(actually 1) time(s)
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
	player.numberOfLoops = 0;
	[player play];
}

//Plays the Low Health Sound
- (void)playlowSound {
	reloadPrefs();

	if (lowsound == 0)
		soundFilePath = [NSString stringWithFormat:@"%@/heal.mp3", bundlePrefix];
	else if (lowsound == 1)
		soundFilePath = [NSString stringWithFormat:@"%@/lowhealth.mp3", bundlePrefix];
	else if (lowsound == 2)
		soundFilePath = [NSString stringWithFormat:@"%@/solidalert.mp3", bundlePrefix];
	else if (lowsound == 3)
		soundFilePath = [NSString stringWithFormat:@"%@/switch_bing.wav", bundlePrefix];
	else if (lowsound == 4)
		soundFilePath = [NSString stringWithFormat:@"%@/switch_enter.wav", bundlePrefix];
	else if (lowsound == 5)
		soundFilePath = [NSString stringWithFormat:@"%@/switch_user.wav", bundlePrefix];
	else
		soundFilePath = [NSString stringWithFormat:@"%@/lowhealth.mp3", bundlePrefix];

	soundFileURL = [NSURL fileURLWithPath:soundFilePath];

	lowplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
	lowplayer.numberOfLoops = 0;
	[lowplayer play];
}

//Same method as the Tweak.xm
static void reloadPrefs() {
  CFPreferencesAppSynchronize((CFStringRef)kIdentifier);

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

  sound = [prefs objectForKey:@"sound"] ? [[prefs objectForKey:@"sound"] integerValue] : 0;
  lowsound = [prefs objectForKey:@"lowsound"] ? [[prefs objectForKey:@"lowsound"] integerValue] : 1;
}
@end
