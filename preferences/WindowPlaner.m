#define PLIST_PATH @"/var/mobile/Library/Preferences/com.apple.springboard.plist"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Preferences/PSListController.h"
@interface windowPlanerPrefsController : PSListController {
}
@end

@implementation windowPlanerPrefsController

-(NSString*) navigationTitle {
  return @"WindowPlaner";
}

-(NSArray*) specifiers {
  return [self loadSpecifiersFromPlistName:@"WindowPlaner" target:self];
}

-(void) respring: (id)unused {
	system("killall SpringBoard");
}

@end
