//
//  RimeWrapper.h
//  XIME
//
//  Created by Stackia <jsq2627@gmail.com> on 10/18/14.
//  Copyright (c) 2014 Stackia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RimeTypeDef.h"

// Import necessary key codes
#include "keysymdef.h"
//#import <Carbon/Carbon.h>
#define kMaxCandidateListCount 300
// Typedef from Rime API
typedef uintptr_t RimeSessionId;
typedef enum {
    kShiftMask    = 1 << 0,
    kLockMask     = 1 << 1,
    kControlMask  = 1 << 2,
    kMod1Mask     = 1 << 3,
    kAltMask      = kMod1Mask,
    kMod2Mask     = 1 << 4,
    kMod3Mask     = 1 << 5,
    kMod4Mask     = 1 << 6,
    kMod5Mask     = 1 << 7,
    kButton1Mask  = 1 << 8,
    kButton2Mask  = 1 << 9,
    kButton3Mask  = 1 << 10,
    kButton4Mask  = 1 << 11,
    kButton5Mask  = 1 << 12,
    kHandledMask  = 1 << 24,
    kForwardMask  = 1 << 25,
    kIgnoredMask  = kForwardMask,
    kSuperMask    = 1 << 26,
    kHyperMask    = 1 << 27,
    kMetaMask     = 1 << 28,
    kReleaseMask  = 1 << 30,
    kModifierMask = 0x5f001fff
} RimeModifier;

/// Rime notification protocol, used for receiving Rime notifications.
@protocol RimeNotificationDelegate <NSObject>

@optional
- (void)onDeploymentStarted;
- (void)onDeploymentSuccessful;
- (void)onDeploymentFailed;
- (void)onSchemaChangedWithNewSchema:(NSString *)schema;
- (void)onOptionChangedWithOption:(XRimeOption)option value:(BOOL)value;

@end

@interface RimeWrapper : NSObject

/// Set Rime notification delegate
+ (void)setNotificationDelegate:(id<RimeNotificationDelegate>)delegate;

/// Start Rime service. This will setup notification handler, logging and deployer. And then start the service and perform a fast deployment.
+ (BOOL)startService;

/// Stop Rime service
+ (void)stopService;

/// With fast == YES, Rime will get deployed only when there is a newer version of config. Otherwise it will always get deployed.
+ (void)deployWithFastMode:(BOOL)fastMode;

/// Restart Rime service and perform a deployment.
+ (void)redeployWithFastMode:(BOOL)fastMode;

/// Create a Rime session
+ (RimeSessionId)createSession;

/// Destroy a Rime session
+ (void)destroySession:(RimeSessionId)sessiodId;

/// Return whether the specificed session exists
+ (BOOL)isSessionAlive:(RimeSessionId)sessionId;

/// Process key with Rime key code and modifier
+ (BOOL)inputKeyForSession:(RimeSessionId)sessionId rimeKeyCode:(int)keyCode rimeModifier:(int)modifier;

/// Convert a case sensitive character to Rime key code
+ (int)rimeKeyCodeForKeyChar:(char)keyChar;

/// Convert OS X key code to Rime key code. If keyCode is not recognized, return 0.
+ (int)rimeKeyCodeForOSXKeyCode:(int)keyCode;

/// Convert OS X modifier to Rime modifier
+ (int)rimeModifierForOSXModifier:(int)modifier;

/// Commit composition. The composed text can be later consumed by consumeComposedTextForSession:(RimeSessionId)sessionId.
+ (BOOL)commitCompositionForSession:(RimeSessionId)sessionId;

/// Consume composed text. Return nil if there is nothing to consume.
+ (NSString *)consumeComposedTextForSession:(RimeSessionId)sessionId;

/// Clear composition buffer.
+ (void)clearCompositionForSession:(RimeSessionId)sessionId;

/// Get the Rime context for a session
+ (XRimeContext *)contextForSession:(RimeSessionId)sessiodId;

/// Get option state for a session
+ (BOOL)getOptionStateForSession:(RimeSessionId)sessionId optionName:(NSString *)optionName;

+(NSArray*)getCandidateListForSession:(RimeSessionId)sessionId andIndex:(NSInteger)index andCount:(NSInteger)count;

+ (NSArray *)getCandidateListForSession:(RimeSessionId)sessionId;

+ (BOOL)selectCandidateForSession:(RimeSessionId)seesionId inIndex:(size_t)index;

//get the schema list


//RIME_API Bool RimeGetSchemaList(RimeSchemaList* schema_list);
//RIME_API void RimeFreeSchemaList(RimeSchemaList* schema_list);
//RIME_API Bool RimeGetCurrentSchema(RimeSessionId session_id, char* schema_id, size_t buffer_size);
//RIME_API Bool RimeSelectSchema(RimeSessionId session_id, const char* schema_id);

+(NSArray*)getSchemaList;
//+(void)freeSchemaList();
//+(void)getCurrentSchema();
+(void)selectSchemaInRimeSeesiong:(RimeSessionId) seesionId useSchemaId:(const char*) schemaId;


+(BOOL)RimeDeployWorkspace;

@end
