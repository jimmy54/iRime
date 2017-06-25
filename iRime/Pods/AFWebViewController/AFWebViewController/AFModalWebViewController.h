//
//  AFModalWebViewController.h
//  AFWebViewController
//
//  Created by Anders Eriksen on 09/11/14.
//  Copyright (c) 2014-2015 Fogh Development. All rights reserved.
//

@import UIKit;
@class WKWebViewConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface AFModalWebViewController : UINavigationController

/**
 *  Instantiate a modal WebViewController with URL address string.
 *
 *  @param urlString String with URL to show in web view.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
+ (instancetype)webViewControllerWithAddress:(NSString *)urlString;

/**
 *  Instantiate a modal WebViewController with URL.
 *
 *  @param URL URL with address to show in web view.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
+ (instancetype)webViewControllerWithURL:(NSURL *)URL;

/**
 *  Instantiate a modal WebViewController with URL request.
 *
 *  @param request NSURLRequest to show in web view.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
+ (instancetype)webViewControllerWithURLRequest:(NSURLRequest *)request;

/**
 *  Instantiate a modal WebViewController with HTML string and base URL.
 *
 *  @param HTMLString HTML string to show in web view.
 *  @param baseURL    Base URL containing local files like stylesheets etc.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
+ (instancetype)webViewControllerWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL;

/**
 *  Instantiate a modal WebViewController with URL address string.
 *
 *  @param urlString String with URL to show in web view.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
- (instancetype)initWithAddress:(NSString *)urlString;

/**
 *  Instantiate a modal WebViewController with URL.
 *
 *  @param URL URL with address to show in web view.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
- (instancetype)initWithURL:(NSURL *)URL;

/**
 *  Instantiate a modal WebViewController with URL request.
 *
 *  @param request NSURLRequest to show in web view.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

/**
 *  Instantiate a modal WebViewController with URL request.
 *
 *  @param request        NSURLRequest to show in web view.
 *  @param configuration  a collection of properties used to initialize a web view.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
- (instancetype)initWithURLRequest:(NSURLRequest *)request configuration:(nullable WKWebViewConfiguration *)configuration;

/**
 *  Instantiate a modal WebViewController with HTML string and base URL.
 *
 *  @param HTMLString HTML string to show in web view.
 *  @param baseURL    Base URL containing local files like stylesheets etc.
 *
 *  @return Instance of `AFModalWebViewController`.
 */
- (instancetype)initWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL;

/**
 *  Tint color for navigation bar.
 */
@property (nonatomic, strong) UIColor *barsTintColor;

/**
 *  Tint color for tool bar.
 */
@property (nonatomic, strong) UIColor *toolbarTintColor;

@end

NS_ASSUME_NONNULL_END
