AFWebViewController
===================
![Pod version](http://img.shields.io/cocoapods/v/AFWebViewController.svg?style=flat)
![Pod platform](http://img.shields.io/cocoapods/p/AFWebViewController.svg?style=flat)
[![Build Status](http://img.shields.io/travis/Fogh/AFWebViewController.svg?style=flat)](https://travis-ci.org/Fogh/AFWebViewController)

In-app browser

## Description

In-app browser for quick implementation in your app. Pretty much inspired by [`SVWebViewController`](https://github.com/TransitApp/SVWebViewController). 
Uses [`WKWebView`](https://developer.apple.com/library/IOs/documentation/WebKit/Reference/WKWebView_Ref/index.html) for a much faster browsing experience. 

**Requires iOS 8+**

## Installation with [CocoaPods](http://cocoapods.org/)

Install with CocoaPods and import `AFWebViewController.h` or `AFModalWebViewController.h` where you want to use it.

### Podfile

```ruby
platform :ios, '8.0'
pod 'AFWebViewController', '~> 1.0'
```

## Usage example

**Push `AFWebViewController`:**
```objectivec
AFWebViewController *webViewController = [AFWebViewController webViewControllerWithAddress:@"https://google.com"];
webViewController.toolbarTintColor = [UIColor orangeColor]; // Does not work on iPad
[self.navigationController pushViewController:webViewController animated:YES];
```

**Modal `AFWebViewController`:**
```objectivec
AFModalWebViewController *webViewController = [AFModalWebViewController webViewControllerWithAddress:@"https://google.com"];
webViewController.barsTintColor = [UIColor redColor];
webViewController.toolbarTintColor = [UIColor orangeColor]; // Does not work on iPad
[self presentViewController:webViewController animated:YES completion:NULL];
```

## Other iOS open source projects by me

- [AFAddressBookManager](https://github.com/Fogh/AFAddressBookManager)
- [AFMobilePayRequestHandler](https://github.com/Fogh/AFMobilePayRequestHandler)
