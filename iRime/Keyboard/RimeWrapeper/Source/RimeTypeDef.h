//
//  RimeTypeDef.h
//  XIME
//
//  Created by Stackia <jsq2627@gmail.com> on 10/20/14.
//  Copyright (c) 2014 Stackia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Here are some Rime structs wrapped in Objective-C NSObject.
 * The original struct name prefixed with 'X' is the wrapped class name.
 *
 * - XRimeContext
 * - XRimeCandidate
 * - XRimeMenu
 * - XRimeComposition
 * 
 * And some custom enumeration.
 *
 * - XRimeOption
 */

typedef enum : NSUInteger {
    XRimeOptionUndefined,
    XRimeOptionASCIIMode,
    XRimeOptionFullShape,
    XRimeOptionASCIIPunct,
    XRimeOptionSimplification,
    XRimeOptionExtendedCharset,
} XRimeOption;

@interface XRimeCandidate : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *comment;

@end

@interface XRimeMenu : NSObject

@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, assign) int highlightedCandidateIndex;
@property (nonatomic, strong) NSArray *candidates;
@property (nonatomic, strong) NSString *selectKeys;

@end

@interface XRimeComposition : NSObject

@property (nonatomic, assign) int cursorPosition;
@property (nonatomic, assign) int selectionStart;
@property (nonatomic, assign) int selectionEnd;
@property (nonatomic, strong) NSString *preeditedText;

@end

@interface XRimeContext : NSObject

@property (nonatomic, strong) XRimeComposition *composition;
@property (nonatomic, strong) XRimeMenu *menu;
@property (nonatomic, strong) NSString *commitTextPreview;

@end