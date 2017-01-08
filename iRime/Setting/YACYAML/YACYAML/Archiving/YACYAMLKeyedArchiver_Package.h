//
//  YACYAMLKeyedArchiver_Package.h
//  YACYAML
//
//  Created by James Montgomerie on 18/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YACYAMLArchivingObject;

@interface YACYAMLKeyedArchiver ()

@property (nonatomic, readonly) BOOL scalarAnchorsAllowed;

- (void)pushArchivingObject:(YACYAMLArchivingObject *)archivingObject;
- (void)popArchivingObject;
- (void)noteNonAnchoringObject:(YACYAMLArchivingObject *)archivingObject;

- (YACYAMLArchivingObject *)previouslySeenArchivingObjectForObject:(id)object;
- (NSString *)generateAnchor;

@end
