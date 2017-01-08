# ARChromeActivity

#### A UIActivity subclass for opening URLs in Google Chrome.

## Usage

Typical usage will look something like this:

	NSURL *urlToShare = [NSURL URLWithString:@"https://github.com/alextrob/ARChromeActivity"];
	NSArray *activityItems = [NSArray arrayWithObject:urlToShare];

	ARChromeActivity *chromeActivity = [[ARChromeActivity alloc] init];
	NSArray *applicationActivities = [NSArray arrayWithObject:chromeActivity];

	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
	
	[self presentViewController:activityVC animated:YES completion:nil];

It also supports `x-callback-url` by either initializing with `initWithCallbackURL:`, or setting the `callbackURL` property. Note that if you set a `callbackURL` under iOS 9, you will be required to add "googlechrome-x-callback" to your Info.plist under `LSApplicationQueriesSchemes`.

Have a look at the demo app!

![Demo screenshot](https://raw.github.com/alextrob/ARChromeActivity/master/screenshot.png)
