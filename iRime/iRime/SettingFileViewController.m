
#import "SettingFileViewController.h"
#ifdef USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKSpecifier.h"
#else
#import "IASKSpecifier.h"
#endif

#import <GCDWebUploader.h>

#import "NSString+Path.h"

#import <Reachability/Reachability.h>

#import <SVProgressHUD.h>

#import "RimeConfigController.h"



@interface SettingFileViewController ()<GCDWebUploaderDelegate>


@property(nonatomic, weak)IBOutlet UIView *noWiFiView;
@property(nonatomic, weak)IBOutlet UIButton *urlBtn;

@end

@implementation SettingFileViewController{
@private
    GCDWebUploader* _webServer;
}

- (id)initWithFile:(NSString*)file specifier:(IASKSpecifier*)specifier {
    if ((self = [super init])) {
        // custom initialization
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"配置你的输入法";
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
   [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    [self netMonitor];
    
   
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    [self stopWebServer];
    
    
    [[RimeConfigController sharedInstance] reloadConfig];
}

-(void)netMonitor
{
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"");
        if (reach.reachableOnWWAN) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self startWebServer];
                self.noWiFiView.hidden = YES;
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stopWebServer];
                self.noWiFiView.hidden = NO;
                
            });
            
        }
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"unable");
        if (reach.reachableOnWWAN) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopWebServer];
                self.noWiFiView.hidden = NO;
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stopWebServer];
                self.noWiFiView.hidden = NO;
                
            });
            
        }

    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
}

-(void)stopWebServer
{
    if (_webServer == nil) {
        return;
    }
    
    [_webServer stop];
    _webServer = nil;   
}

-(void)startWebServer
{
    [self stopWebServer];
    
    if (_webServer && _webServer.running) {
        return;
    }
    
    _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:[NSString rimeResource]];
    _webServer.delegate = self;
    _webServer.allowHiddenItems = YES;

    NSString *text = nil;

    if ([_webServer start]) {
        text = [NSString stringWithFormat:@"%@", _webServer.serverURL];
        [self.urlBtn setTitle:text forState:UIControlStateNormal];
    }else{
        NSLog(@"启动网页服务器失败");
        [self.urlBtn setTitle:@"启动服务器失败了！请重试一下。" forState:UIControlStateNormal];
    }
}


-(IBAction)tapCopy:(id)sender
{
    [SVProgressHUD showInfoWithStatus:@"已经复制到粘帖板"];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.urlBtn.titleLabel.text];
    
}

@end
