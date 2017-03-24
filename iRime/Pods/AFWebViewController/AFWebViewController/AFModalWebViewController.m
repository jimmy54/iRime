//
//  AFModalWebViewController.m
//  AFWebViewController
//
//  Created by Anders Eriksen on 09/11/14.
//  Copyright (c) 2014-2015 Fogh Development. All rights reserved.
//

#import "AFModalWebViewController.h"
#import "AFWebViewController.h"

@interface AFModalWebViewController ()
@property (nonatomic, strong) AFWebViewController *webViewController;
@end

@interface AFWebViewController (DoneButton)

- (void)doneButtonTapped:(id)sender;

@end

@implementation AFModalWebViewController

#pragma mark - Initialization

+ (instancetype)webViewControllerWithAddress:(NSString *)urlString {
    return [[self alloc] initWithAddress:urlString];
}

+ (instancetype)webViewControllerWithURL:(NSURL *)URL {
    return [[self alloc] initWithURL:URL];
}

+ (instancetype)webViewControllerWithURLRequest:(NSURLRequest *)request {
    return [[self alloc] initWithURLRequest:request];
}

+ (instancetype)webViewControllerWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL {
    return [[self alloc] initWithHTMLString:HTMLString andBaseURL:baseURL];
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    return [self initWithURLRequest:request configuration:nil];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request
                     configuration:(WKWebViewConfiguration *)configuration
{
    self.webViewController = [[AFWebViewController alloc] initWithURLRequest:request configuration:configuration];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.webViewController action:@selector(doneButtonTapped:)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.webViewController.navigationItem.leftBarButtonItem = doneButton;
        }
        else {
            self.webViewController.navigationItem.rightBarButtonItem = doneButton;
        }
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL {
    self.webViewController = [[AFWebViewController alloc] initWithHTMLString:HTMLString andBaseURL:baseURL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.webViewController action:@selector(doneButtonTapped:)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.webViewController.navigationItem.leftBarButtonItem = doneButton;
        }
        else {
            self.webViewController.navigationItem.rightBarButtonItem = doneButton;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

- (void)setToolbarTintColor:(UIColor *)color {
    _toolbarTintColor = color;
    self.webViewController.toolbarTintColor = _toolbarTintColor;
}

@end
