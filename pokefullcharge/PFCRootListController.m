#include "PFCRootListController.h"
#import <UIKit/UIKit.h>

//Paths and such
#define kSettingsPath @"/var/mobile/Library/Preferences/com.6ilent.pokefullcharge.plist"
#define kSettingsChangedNotification (CFStringRef)@"com.6ilent.pokefullcharge/ReloadPrefs"
#define prefsAppID CFSTR("com.6ilent.pokefullcharge")

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
@end