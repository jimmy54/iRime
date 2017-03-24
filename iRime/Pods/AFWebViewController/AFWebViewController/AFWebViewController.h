//
//  AFWebViewController.h
//  AFWebViewController
//
//  Created by Anders Eriksen on 09/11/14.
//  Copyright (c) 2014-2015 Fogh Development. All rights reserved.
//

@import UIKit;
@class WKWebView;
@class WKWebViewConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface AFWebViewController : UIViewController

@property (nonatomic, strong, readonly) WKWebView *webView;

/**
 *  Instantiate WebViewController with URL address string.
 *
 *  @param urlString String with URL to show in web view.
 *
 *  @return Instance of `AFWebViewController`.
 */
+ (instancetype)webViewControllerWithAddress:(NSString *)urlString;

/**
 *  Instantiate WebViewController with URL.
 *
 *  @param URL URL with address to show in web view.
 *
 *  @return Instance of `AFWebViewController`.
 */
+ (instancetype)webViewControllerWithURL:(NSURL *)URL;

/**
 *  Instantiate WebViewController with URL request.
 *
 *  @param request NSURLRequest to show in web view.
 *
 *  @return Instance of `AFWebViewController`.
 */
+ (instancetype)webViewControllerWithURLRequest:(NSURLRequest *)request;

/**
 *  Instantiate WebViewController with HTML string and base URL.
 *
 *  @param HTMLString HTML string to show in web view.
 *  @param baseURL    Base URL containing local files like stylesheets etc.
 *
 *  @return Instance of `AFWebViewController`.
 */
+ (instancetype)webViewControllerWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL;

/**
 *  Instantiate WebViewController with URL address string.
 *
 *  @param urlString String with URL to show in web view.
 *
 *  @return Instance of `AFWebViewController`.
 */
- (instancetype)initWithAddress:(NSString *)urlString;

/**
 *  Instantiate WebViewController with URL.
 *
 *  @param URL URL with address to show in web view.
 *
 *  @return Instance of `AFWebViewController`.
 */
- (instancetype)initWithURL:(NSURL *)URL;

/**
 *  Instantiate WebViewController with URL request.
 *
 *  @param request NSURLRequest to show in web view.
 *
 *  @return Instance of `AFWebViewController`.
 */
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

/**
 *  Instantiate WebViewController with URL request.
 *
 *  @param request        NSURLRequest to show in web view.
 *  @param configuration  a collection of properties used to initialize a web view.
 *
 *  @return Instance of `AFWebViewController`.
 */
- (instancetype)initWithURLRequest:(NSURLRequest *)request configuration:(nullable WKWebViewConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 *  Instantiate WebViewController with HTML string and base URL.
 *
 *  @param HTMLString HTML string to show in web view.
 *  @param baseURL    Base URL containing local files like stylesheets etc.
 *
 *  @return Instance of `AFWebViewController`.
 */
- (instancetype)initWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

/**
 *  Tint color for tool bar.
 */
@property (nonatomic, strong) UIColor *toolbarTintColor;

@end

NS_ASSUME_NONNULL_END

