//
//  RimeWrapper.m
//  XIME
//
//  Created by Stackia <jsq2627@gmail.com> on 10/18/14.
//  Copyright (c) 2014 Stackia. All rights reserved.
//

#import "RimeWrapper.h"
#import "NSString+UTF8Utils.h"
#include "rime_api.h"


#import "NSString+Path.h"

// All const definitions here
#define kXIMEUserDataDirectoryKey @"XIMEUserDataDirectory"
#define kXIMECandidateWindowPositionVerticalOffset 5





/* keycodes for keys that are independent of keyboard layout*/
enum {
    kVK_Return                    = 0x24,
    kVK_Tab                       = 0x30,
    kVK_Space                     = 0x31,
    kVK_Delete                    = 0x33,
    kVK_Escape                    = 0x35,
    kVK_Command                   = 0x37,
    kVK_Shift                     = 0x38,
    kVK_CapsLock                  = 0x39,
    kVK_Option                    = 0x3A,
    kVK_Control                   = 0x3B,
    kVK_RightShift                = 0x3C,
    kVK_RightOption               = 0x3D,
    kVK_RightControl              = 0x3E,
    kVK_Function                  = 0x3F,
    kVK_F17                       = 0x40,
    kVK_VolumeUp                  = 0x48,
    kVK_VolumeDown                = 0x49,
    kVK_Mute                      = 0x4A,
    kVK_F18                       = 0x4F,
    kVK_F19                       = 0x50,
    kVK_F20                       = 0x5A,
    kVK_F5                        = 0x60,
    kVK_F6                        = 0x61,
    kVK_F7                        = 0x62,
    kVK_F3                        = 0x63,
    kVK_F8                        = 0x64,
    kVK_F9                        = 0x65,
    kVK_F11                       = 0x67,
    kVK_F13                       = 0x69,
    kVK_F16                       = 0x6A,
    kVK_F14                       = 0x6B,
    kVK_F10                       = 0x6D,
    kVK_F12                       = 0x6F,
    kVK_F15                       = 0x71,
    kVK_Help                      = 0x72,
    kVK_Home                      = 0x73,
    kVK_PageUp                    = 0x74,
    kVK_ForwardDelete             = 0x75,
    kVK_F4                        = 0x76,
    kVK_End                       = 0x77,
    kVK_F2                        = 0x78,
    kVK_PageDown                  = 0x79,
    kVK_F1                        = 0x7A,
    kVK_LeftArrow                 = 0x7B,
    kVK_RightArrow                = 0x7C,
    kVK_DownArrow                 = 0x7D,
    kVK_UpArrow                   = 0x7E
};


/* Device-independent bits found in event modifier flags */
typedef NS_OPTIONS(NSUInteger, NSEventModifierFlags) {
    NSAlphaShiftKeyMask         = 1 << 16,
    NSShiftKeyMask              = 1 << 17,
    NSControlKeyMask            = 1 << 18,
    NSAlternateKeyMask          = 1 << 19,
    NSCommandKeyMask            = 1 << 20,
    NSNumericPadKeyMask         = 1 << 21,
    NSHelpKeyMask               = 1 << 22,
    NSFunctionKeyMask           = 1 << 23,
    NSDeviceIndependentModifierFlagsMask    = 0xffff0000UL
};




static id<RimeNotificationDelegate> notificationDelegate_ = nil;

void notificationHandler(void* context_object, RimeSessionId session_id, const char* message_type, const char* message_value) {
    
    if (notificationDelegate_ == nil) {
        return;
    }
    
    if (!strcmp(message_type, "deploy")) { // Deployment state change
        
        if (!strcmp(message_value, "start")) {
            if ([notificationDelegate_ respondsToSelector:@selector(onDeploymentStarted)]) {
                [notificationDelegate_ onDeploymentStarted];
            }
        }
        else if (!strcmp(message_value, "success")) {
            if ([notificationDelegate_ respondsToSelector:@selector(onDeploymentSuccessful)]) {
                [notificationDelegate_ onDeploymentSuccessful];
            }
        }
        else if (!strcmp(message_value, "failure")) {
            if ([notificationDelegate_ respondsToSelector:@selector(onDeploymentFailed)]) {
                [notificationDelegate_ onDeploymentFailed];
            }
        }
        
    } else if (!strcmp(message_type, "schema") && [notificationDelegate_ respondsToSelector:@selector(onSchemaChangedWithNewSchema:)]) { // Schema change
        
        const char* schema_name = strchr(message_value, '/');
        if (schema_name) {
            ++schema_name;
            [notificationDelegate_ onSchemaChangedWithNewSchema:[NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:schema_name]]];
        }
        
    } else if (!strcmp(message_type, "option") && [notificationDelegate_ respondsToSelector:@selector(onOptionChangedWithOption:value:)]) { // Option change
        
        XRimeOption option = XRimeOptionUndefined;
        BOOL value = (message_value[0] != '!');;
        
        if (!strcmp(message_value, "ascii_mode") || !strcmp(message_value, "!ascii_mode")) {
            option = XRimeOptionASCIIMode;
        }
        else if (!strcmp(message_value, "full_shape") || !strcmp(message_value, "!full_shape")) {
            option = XRimeOptionFullShape;
        }
        else if (!strcmp(message_value, "ascii_punct") || !strcmp(message_value, "!ascii_punct")) {
            option = XRimeOptionASCIIPunct;
        }
        else if (!strcmp(message_value, "simplification") || !strcmp(message_value, "!simplification")) {
            option = XRimeOptionSimplification;
        }
        else if (!strcmp(message_value, "extended_charset") || !strcmp(message_value, "!extended_charset")) {
            option = XRimeOptionExtendedCharset;
        }
        
        [notificationDelegate_ onOptionChangedWithOption:option value:value];
        
    }
}

@implementation RimeWrapper

+ (void)setNotificationDelegate:(id<RimeNotificationDelegate>)delegate {
    notificationDelegate_ = delegate;
}

+ (BOOL)startService {
    
    NSString *rimePath = nil;
    NSString *shareSupportPath = nil;
    NSString *userPath = nil;
    
    shareSupportPath = [NSString appendingHostAppBundlePath:@"SharedSupport"];
    rimePath = [NSString rimeResource];
    userPath = [NSString userPath];
    
    
    NSError *err = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:rimePath]) {
        if (![fileManager createDirectoryAtPath:rimePath withIntermediateDirectories:YES attributes:nil error:&err]) {
            NSLog(@"Failed to create rime data directory. err:%@", err);
            return NO;
        }
    }
    
    if (![fileManager fileExistsAtPath:userPath]) {
        if (![fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:&err]) {
            NSLog(@"Failed to create user data directory.  err :%@", err);
        }
    }
    
    RIME_STRUCT(RimeTraits, vXIMETraits);
    vXIMETraits.shared_data_dir = [shareSupportPath UTF8String];
    vXIMETraits.user_data_dir = [rimePath UTF8String];
    /*test


    BOOL res = NO;
    NSString *dir = [NSString stringWithFormat:@"%@/%@", rimePath, @"testDir"];
    NSFileManager * f = [NSFileManager defaultManager];
    NSURL * url = [f containerURLForSecurityApplicationGroupIdentifier:GROUP_ID];
    
    res = [f createDirectoryAtPath:[url absoluteString] withIntermediateDirectories:YES attributes:NULL error:&err];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"test----", nil];
    dir = [NSString stringWithFormat:@"%@/%@", rimePath, @"test.txt"];
     res = [dic writeToFile:dir atomically:YES];
    if (res == NO) {
        NSLog(@"create the file error!");
    }
    */
    vXIMETraits.distribution_name = "iRime";
    vXIMETraits.distribution_code_name = "iRime";
    vXIMETraits.distribution_version = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] UTF8String];
    vXIMETraits.app_name = "iRime";
    
    // Set Rime notification handler
    RimeSetNotificationHandler(notificationHandler, (__bridge void *)self);
    
    // Setup deployer and logging
    RimeSetup(&vXIMETraits);
    
    // Load modules and start service
    RimeInitialize(NULL);
    
    // Fast deploy
    [self deployWithFastMode:YES];
    
    return YES;
}

+ (void)stopService {
    RimeCleanupAllSessions();
    RimeFinalize();
}

+ (void)deployWithFastMode:(BOOL)fastMode {
    if (fastMode) {
        // If default.yaml config_version is changed, schedule a maintenance
        RimeStartMaintenance(False); // full_check = False to check config_version first, return True if a maintenance is triggered
    } else {
        // Maintenance with full checkz
        RimeStartMaintenance(True);
    }
}

+ (void)redeployWithFastMode:(BOOL)fastMode {
    // Restart service
    RimeFinalize();
    RimeInitialize(NULL);
    
    // Deploy
    [self deployWithFastMode:fastMode];
}

+ (RimeSessionId)createSession {
    return RimeCreateSession();
}

+ (void)destroySession:(RimeSessionId)sessionId {
    RimeDestroySession(sessionId);
}

+ (BOOL)isSessionAlive:(RimeSessionId)sessionId {
    return RimeFindSession(sessionId) == True;
}

+ (BOOL)inputKeyForSession:(RimeSessionId)sessionId rimeKeyCode:(int)keyCode rimeModifier:(int)modifier {
    return RimeProcessKey(sessionId, keyCode, modifier) == True;
}

+ (int)rimeKeyCodeForKeyChar:(char)keyChar {
    int ret = 0;
    if (keyChar >= 0x20 && keyChar <= 0x7e) {
        ret = keyChar;
    }
    else if (keyChar == 0x1b) {  // ^[ left bracket
        ret = XK_bracketleft;
    }
    else if (keyChar == 0x1c) {  // ^\ backslash
        ret = XK_backslash;
    }
    else if (keyChar == 0x1d) {  // ^] right bracket
        ret = XK_bracketright;
    }
    else if (keyChar == 0x1f) {  // ^_ minus
        ret = XK_minus;
    }
    return ret;
}

+ (int)rimeKeyCodeForOSXKeyCode:(int)keyCode {
    int ret = 0;
    switch (keyCode) {
        case kVK_Space:
            ret = XK_space;
            break;
        case kVK_Tab:
            ret = XK_Tab;
            break;
        case kVK_Return:
            ret = XK_Return;
            break;
        case kVK_Delete:
            ret = XK_BackSpace;
            break;
        case kVK_Escape:
            ret = XK_Escape;
            break;
        case kVK_PageUp:
            ret = XK_Prior;
            break;
        case kVK_PageDown:
            ret = XK_Next;
            break;
        case kVK_End:
            ret = XK_End;
            break;
        case kVK_Home:
            ret = XK_Home;
            break;
        case kVK_LeftArrow:
            ret = XK_Left;
            break;
        case kVK_UpArrow:
            ret = XK_Up;
            break;
        case kVK_RightArrow:
            ret = XK_Right;
            break;
        case kVK_DownArrow:
            ret = XK_Down;
            break;
        case kVK_ForwardDelete:
            ret = XK_Delete;
            break;
        case kVK_Control:
            ret = XK_Control_L;
            break;
        case kVK_RightControl:
            ret = XK_Control_R;
            break;
        case kVK_Shift:
            ret = XK_Shift_L;
            break;
        case kVK_RightShift:
            ret = XK_Shift_R;
            break;
        case kVK_Option:
            ret = XK_Alt_L;
            break;
        default:
            ret = 0;
            break;
    }
    return ret;
}

+ (int)rimeModifierForOSXModifier:(int)modifier {
    int ret = 0;
    if (modifier & NSAlphaShiftKeyMask)
        ret |= kLockMask;
    if (modifier & NSShiftKeyMask)
        ret |= kShiftMask;
    if (modifier & NSControlKeyMask)
        ret |= kControlMask;
    if (modifier & NSAlternateKeyMask)
        ret |= kAltMask;
    if (modifier & NSCommandKeyMask)
        ret |= kSuperMask;
    return ret;
}

+ (BOOL)commitCompositionForSession:(RimeSessionId)sessionId {
    return RimeCommitComposition(sessionId) == True;
}

+ (NSString *)consumeComposedTextForSession:(RimeSessionId)sessionId {
    NSString *composedText;
    RIME_STRUCT(RimeCommit, commit);
    if (RimeGetCommit(sessionId, &commit)) {
        composedText = [NSString stringWithUTF8String:commit.text];
        RimeFreeCommit(&commit);
    }
    return composedText;
}

+ (void)clearCompositionForSession:(RimeSessionId)sessionId {
    RimeClearComposition(sessionId);
}

+ (XRimeContext *)contextForSession:(RimeSessionId)sessiodId {
    //RIME的结构体转成OC对象
    XRimeContext *xCtx;
    RIME_STRUCT(RimeContext, ctx);
    if (RimeGetContext(sessiodId, &ctx)) {
        xCtx = [[XRimeContext alloc] init];
        if (ctx.commit_text_preview) {
            [xCtx setCommitTextPreview:[NSString stringWithUTF8String:ctx.commit_text_preview]];
        }
        
        XRimeMenu *xMenu = [[XRimeMenu alloc] init];
        XRimeComposition * xComp = [[XRimeComposition alloc] init];
        [xCtx setMenu:xMenu];
        [xCtx setComposition:xComp];
        
        [xMenu setPageSize:ctx.menu.page_size];
        [xMenu setPageNumber:ctx.menu.page_no];
        [xMenu setIsLastPage:ctx.menu.is_last_page == True];
        [xMenu setHighlightedCandidateIndex:ctx.menu.highlighted_candidate_index];
        if (ctx.menu.select_keys) {
            [xMenu setSelectKeys:[NSString stringWithUTF8String:ctx.menu.select_keys]];
        }
        NSMutableArray *xCandidates = [NSMutableArray array];
        for (int i = 0; i < ctx.menu.num_candidates; ++i) {
            XRimeCandidate *xCandidate = [[XRimeCandidate alloc] init];
            if (ctx.menu.candidates[i].text) {
                [xCandidate setText:[NSString stringWithUTF8String:ctx.menu.candidates[i].text]];
            }
            if (ctx.menu.candidates[i].comment) {
                [xCandidate setText:[NSString stringWithUTF8String:ctx.menu.candidates[i].comment]];
            }
            [xCandidates addObject:xCandidate];
        }
        [xMenu setCandidates:xCandidates];

        [xComp setCursorPosition:[NSString NSStringPosFromUTF8Pos:ctx.composition.cursor_pos string:ctx.composition.preedit strictMode:NO]];
        [xComp setSelectionStart:[NSString NSStringPosFromUTF8Pos:ctx.composition.sel_start string:ctx.composition.preedit strictMode:YES]];
        [xComp setSelectionEnd: [NSString NSStringPosFromUTF8Pos:ctx.composition.sel_end string:ctx.composition.preedit strictMode:YES]];
        if (ctx.composition.preedit) {
            [xComp setPreeditedText:[NSString stringWithUTF8String:ctx.composition.preedit]];
        } else {
            [xComp setPreeditedText:@""];
        }
        RimeFreeContext(&ctx);
    }
    return xCtx;
}

+ (BOOL)getOptionStateForSession:(RimeSessionId)sessionId optionName:(NSString *)optionName {
    return RimeGetOption(sessionId, [optionName UTF8String]);
}


+ (NSArray *)getCandidateListForSession:(RimeSessionId)sessionId
{
    //candidate
    RimeCandidateListIterator ite;
    NSMutableArray *candidates = [NSMutableArray new];
    
    @autoreleasepool {
        
    
        bool res = RimeCandidateListBegin(sessionId, &ite);
        if (res == false) {
            return nil;
        }
        
        NSString *s = nil;
        while (RimeCandidateListNext(&ite)) {
            
            if (ite.index > kMaxCandidateListCount) {
                break;
            }
            s = [NSString stringWithUTF8String:ite.candidate.text];
//            NSLog(@"%@", s);
            [candidates addObject:s];
        }
        
        RimeCandidateListEnd(&ite);
    }
    return candidates;
}

+(NSArray*)getCandidateListForSession:(RimeSessionId)sessionId andIndex:(NSInteger)index andCount:(NSInteger)count
{
     NSMutableArray *candidates = [NSMutableArray new];
    if (index > kMaxCandidateListCount) {
        return candidates;
    }
    
    //candidate
    RimeCandidateListIterator ite;
    
    @autoreleasepool {
        
        bool res = RimeCandidateListBeginWithIndex((int)index, sessionId, &ite);
        if (res == false) {
            return nil;
        }
        NSInteger candidateMax = index + count;
        
        
        //NSInteger i = index;
        NSString *s = nil;
        while (RimeCandidateListNext(&ite)) {
            
            if (ite.index > candidateMax) {
                break;
            }
            s = [NSString stringWithUTF8String:ite.candidate.text];
            //NSLog(@"%d:%@", i, s);
//            i++;
            [candidates addObject:s];
        }
        
        RimeCandidateListEnd(&ite);
    }
    
    return candidates;
    
}



+ (BOOL)selectCandidateForSession:(RimeSessionId)seesionId inIndex:(size_t)index
{
    return rime_get_api()->select_candidate(seesionId, index);
}







+(NSArray*)getSchemaList
{
    
    RimeSchemaList schemaList;
    
    Bool r = rime_get_api()->get_schema_list(&schemaList);
    if (r == NO) {
        NSLog(@"get schema list fail");
        return nil;
    }
    
    
    NSMutableArray *res = [NSMutableArray new];
    RimeSchemaListItem *item = nil;
    
    for (int i = 0; i < schemaList.size; i++) {
        
        item = &schemaList.list[i];
        
    }
    
    return res;
}


+(void)getCurrentSchemaWithSessionId:(RimeSessionId) sessionId
{
    size_t size = 32;
    char schemaId[size];
    bool res = RimeGetCurrentSchema(sessionId, schemaId , size);
    if (res == NO) {
        NSLog(@"get current schema id fail;");
        return;
    }
    NSLog(@"%s", schemaId);
}

+(NSString*)getCurrentSchemaNameWithSessionId:(RimeSessionId)sessionId
{

    NSString *schemaName = nil;
//    RIME_API Bool RimeGetStatus(RimeSessionId session_id, RimeStatus* status);
    RIME_STRUCT(RimeStatus, status);
    bool res = RimeGetStatus(sessionId, &status);
    if (res == NO) {
        NSLog(@"get status fail");
        return schemaName;
    }
    
    schemaName = [NSString stringWithUTF8String:status.schema_name];
    RimeFreeStatus(&status);
    return schemaName;
    
}

+(void)selectSchemaInRimeSeesiong:(RimeSessionId) seesionId useSchemaId:(const char*) schemaId
{
    
}


+(BOOL)RimeDeployWorkspace
{
    return RimeDeployWorkspace();
}

@end
