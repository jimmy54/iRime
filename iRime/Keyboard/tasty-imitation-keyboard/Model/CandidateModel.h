//
//  CandidateModel.h
//  iRime
//
//  Created by jimmy54 on 26/07/2017.
//  Copyright © 2017 jimmy54. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CandidateModel : NSObject



@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)NSString *comment;
@property(nonatomic, assign)CGSize   textSize;

@end
