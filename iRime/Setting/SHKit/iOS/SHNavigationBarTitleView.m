//
//  SHNavigationBarTitleView.m
//  iClojureDocs
//
//  Created by Neo on 5/15/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import "SHNavigationBarTitleView.h"

@interface SHNavigationBarTitleView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation SHNavigationBarTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    // We use sizes for landscape display as default, saving dynamic adjusting.
    // And it looks better on portrait mode as well.
    // Vertical sizes for portrait display: 44, 24, 44-24; font sizes: 20, 13.
    // Vertical sizes for landscape display: 32, 16, 32-16; font sizes: 16, 12.
    self = [super initWithFrame:CGRectMake(0, 0, 200, 32)];
    
    if (self) {
        [self setBackgroundColor: [UIColor clearColor]];
        [self setAutoresizesSubviews:YES];
        
        CGRect titleFrame = CGRectMake(0, 2, 200, 16);
        _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setText:@""];
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:_titleLabel];
        
        CGRect detailFrame = CGRectMake(0, 16, 200, 32-16);
        _detailLabel = [[UILabel alloc] initWithFrame:detailFrame];
        [_detailLabel setFont:[UIFont systemFontOfSize:12]];
        [_detailLabel setTextAlignment:NSTextAlignmentCenter];
        [_detailLabel setText:@""];
        [_detailLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:_detailLabel];
        
        [self setAutoresizingMask : (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin)];
    }
    
    return self;  
}  


- (void) setTitleText:(NSString *)text {
    [self.titleLabel setText:text];
}

- (void) setDetailText:(NSString *)text {
    [self.detailLabel setText:text];
}

@end
