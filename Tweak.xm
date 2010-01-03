#include <SpringBoard/SBRoundedCornerView.h>

#define kSettingsChangeNotification "com.straitiff.windowplaner.settingschange"

static UIWindow *roundWin;
static SBRoundedCornerView *roundView;

static void UpdateWindowAndView();

%class SBRoundedCornerView
%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)app {
	%orig;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (void (*)(CFNotificationCenterRef, void *, CFStringRef, const void *, CFDictionaryRef))UpdateWindowAndView, CFSTR(kSettingsChangeNotification), NULL, CFNotificationSuspensionBehaviorHold);
	UpdateWindowAndView();
}

- (void)dealloc {
	[roundView removeFromSuperview];
	[roundView release];
	roundView = nil;
	[roundWin setHidden:YES];
	[roundWin release];
	roundWin = nil;
	%orig;
}

%end

static void UpdateWindowAndView()
{
	[roundView removeFromSuperview];
	[roundView release];
	roundView = nil;
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.straitiff.windowplaner.plist"];
	id toggleActiveSetting = [dict objectForKey:@"active"];
	if (toggleActiveSetting ? [toggleActiveSetting boolValue] : YES) {
		id sizeSetting = [dict objectForKey:@"size"];
		CGFloat sliderValue = sizeSetting ? floorf([sizeSetting floatValue]) : 12.0f;
		if (!roundWin) {
			roundWin = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
			roundWin.windowLevel = 99999;
			roundWin.userInteractionEnabled = NO;
			roundWin.hidden = NO;
		}
		roundView = [[$SBRoundedCornerView alloc] initWithCornerRadius:sliderValue size:sliderValue inset:0.0f imageSuperview:nil];
		roundView.frame = [[UIScreen mainScreen] bounds];
		[roundWin addSubview:roundView];
	} else {
		[roundWin setHidden:YES];
		[roundWin release];
		roundWin = nil;
	}
}
