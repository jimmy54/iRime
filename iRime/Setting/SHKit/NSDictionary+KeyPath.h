//
//  NSDictionary+KeyPath.h
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import <Foundation/Foundation.h>

// keypath is a string using the following syntax:
// - key names are separated by .
// - array indexes are in [] (indexes starting at 0)
//
// <key>A</key>
// <dict>
//   <key>B</key>
//   <array>
//     <dict>
//       <key>C</key>
//       <string>avalue</string>
//     </dict>
//   </array>
// </dict>
//
// Then key object C can be accessed with [dict objectForKeyPath:@"A.B[0].C"]

@interface NSDictionary (KeyPath)

- (id)objectForKeyPathArray:(NSArray *)keyPathArray;
- (id)objectForKeyPath:(NSString *)keyPath;
@end

@interface NSMutableDictionary (KeyPath)

- (void)setObject:(id)value forKeyPathArray:(NSArray *)keyPathArray;
- (void)setObject:(id)value forKeyPath:(NSString *)keyPath;
@end
