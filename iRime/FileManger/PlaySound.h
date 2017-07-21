//
//  PlaySound.h
//  iRime
//
//  Created by jimmy on 21/07/2017.
//  Copyright © 2017 jimmy54. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaySound : NSObject


+(BOOL)playSound:(NSString *)soundPath;


+(void)playDefaultSound;
@end
