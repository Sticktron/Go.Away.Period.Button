NSString *settingsPath = @"/var/mobile/Library/Preferences/com.rcrepo.safaridefaultkeyboard.plist";
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
//BOOL enabled = [[prefs objectForKey:@"enabled"] boolValue];
NSString *keyboardSafari = [prefs objectForKey:@"keyboardSafari"];

%hook UITextInputTraits
	-(int) keyboardType {
		if([keyboardSafari isEqualToString:@"default"])  {
			return 0;
			return %orig;
			}
		else if ([keyboardSafari isEqualToString:@"address"]) {
			return 3;
			return %orig;
		}
		else if ([keyboardSafari isEqualToString:@"original"] || [keyboardSafari isEqualToString:@""] || keyboardSafari == nil) {
		return %orig;
		}
		else {
			return %orig;
		}
	}
%end

void loadPreferences() {
    NSLog(@"GoAwayPeriodButton--Settings updated");
}

%ctor {
    // Initialization stuff

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)loadPreferences,
                                    CFSTR("com.rcrepo.safaridefaultkeyboard/prefschanged"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);

    loadPreferences();
}
