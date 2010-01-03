#include <SpringBoard/SBRoundedCornerView.h>
static UIWindow *roundWin;
static SBRoundedCornerView *roundView;

%class SBRoundedCornerView
%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)app {
	
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.straitiff.windowplaner.plist"];
	CGFloat sliderValue = [dict objectForKey:@"size"] ? [[dict objectForKey:@"size"] floatValue] : 12.0f;
	
	sliderValue = floorf(sliderValue);
	
	BOOL toggleActive = [dict objectForKey:@"active"] ? [[dict objectForKey:@"active"] boolValue] : 1;

	%orig;

	if(toggleActive) {
		roundWin = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		roundWin.windowLevel = 99999;
		roundWin.userInteractionEnabled = NO;
		roundWin.hidden = NO;

		roundView = [[$SBRoundedCornerView alloc] initWithCornerRadius:sliderValue size:sliderValue inset:0.0f imageSuperview:nil];
		roundView.frame = [[UIScreen mainScreen] bounds];
		[roundWin addSubview:roundView];
	}
	else {
		roundWin = nil;
		roundView = nil;
	}
}

- (void)dealloc {
	[roundView release];
	[roundWin release];
	%orig;
}

%end
