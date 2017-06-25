//
//  AFWebViewController.m
//  AFWebViewController
//
//  Created by Anders Eriksen on 09/11/14.
//  Copyright (c) 2014-2015 Fogh Development. All rights reserved.
//

#import "AFWebViewController.h"
#import "TUSafariActivity.h"
#import "ARChromeActivity.h"

@import WebKit;

@interface AFWebViewController () <WKNavigationDelegate>

// Bar buttons
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem, *forwardBarButtonItem, *refreshBarButtonItem, *stopBarButtonItem, *actionBarButtonItem;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong, nullable) WKWebViewConfiguration *configuration;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation AFWebViewController

@synthesize webView = _webView;

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
                     configuration:(nullable WKWebViewConfiguration *)configuration
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.request = request;
        self.configuration = configuration;
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)HTMLString andBaseURL:(NSURL *)baseURL {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self.webView loadHTMLString:HTMLString baseURL:baseURL];
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    self.webView.navigationDelegate = nil;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)loadView {
    self.view = self.webView;
    [self loadRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.toolbarTintColor) {
        self.toolbarTintColor = self.navigationController.navigationBar.tintColor;
    }
    
    [self updateToolbarItems];
    [self appendProgressView];
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"AFWebViewController needs to be contained in a UINavigationController. Use AFModalWebViewController for modal presentation.");
    
    [super viewWillAppear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.progressView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.frame.size.width, 0.5);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters

- (WKWebView *)webView {
    if (!_webView) {
        if (_configuration) {
            _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:_configuration];
        } else {
            _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIImage *)frameworkBundleImage:(NSString *)imageName {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    return [UIImage imageNamed:imageName inBundle:frameworkBundle compatibleWithTraitCollection:nil];
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self frameworkBundleImage:@"AFWebViewController.bundle/Back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackTapped:)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self frameworkBundleImage:@"AFWebViewController.bundle/Forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardTapped:)];
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    if (!_stopBarButtonItem) {
        _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTapped:)];
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    if (!_actionBarButtonItem) {
        _actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
    }
    return _actionBarButtonItem;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    }
    return _progressView;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.webView.canGoForward;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fixedSpace.width = 35;
        
        NSArray *items = @[fixedSpace,
                          refreshStopBarButtonItem,
                          fixedSpace,
                          self.backBarButtonItem,
                          fixedSpace,
                          self.forwardBarButtonItem,
                          fixedSpace,
                          self.actionBarButtonItem];
        
        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
    }
    else {
        NSArray *items = @[fixedSpace,
                          self.backBarButtonItem,
                          flexibleSpace,
                          self.forwardBarButtonItem,
                          flexibleSpace,
                          refreshStopBarButtonItem,
                          flexibleSpace,
                          self.actionBarButtonItem,
                          fixedSpace];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.toolbarTintColor;
        self.toolbarItems = items;
    }
}

#pragma mark - Target actions

- (void)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (void)actionButtonTapped:(id)sender {
    NSURL *url = self.webView.URL ?: self.request.URL;
    if (url) {
        // More activities should be added in the future
        NSArray *activities = @[[TUSafariActivity new], [ARChromeActivity new]];
        if ([[url absoluteString] hasPrefix:@"file:///"]) {
            UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
            [documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
        }
        else {
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:activities];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UIPopoverPresentationController *popover = activityController.popoverPresentationController;
                popover.sourceView = self.view;
                popover.barButtonItem = sender;
            }
            
            [self presentViewController:activityController animated:YES completion:NULL];
        }
    }
}

#pragma mark - ProgressView

- (void)appendProgressView {
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = self.webView.estimatedProgress == 1;
        float progress = self.progressView.hidden ? 0 : self.webView.estimatedProgress;
        [self.progressView setProgress:progress animated:YES];
    }
}

#pragma mark - WKNavigation delegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (!self.navigationItem.title) {
        self.navigationItem.title = webView.title;
    }
    
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateToolbarItems];
}

@end
