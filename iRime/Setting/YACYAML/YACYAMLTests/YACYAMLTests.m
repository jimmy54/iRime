//
//  YACYAMLTests.m
//  YACYAMLTests
//
//  Created by James Montgomerie on 17/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAMLTests.h"

#import <UIKit/UIKit.h>

#import <libYAML/yaml.h>

#import <YACYAML/YACYAML.h>

#import <math.h>

@interface YACYAMLKeyedArchiver (testing)
- (NSString *)generateAnchor;
@end

@implementation YACYAMLTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLibYAMLParsing
{
    yaml_parser_t parser;
    yaml_event_t event;

    yaml_parser_initialize(&parser);

    char *input = "[ 'one', 1.01, 1, YES, false ]";
    yaml_parser_set_input_string(&parser, (const yaml_char_t *)input, strlen(input));
    
    BOOL sawError = NO;
    BOOL done = NO;
    while(!done) {
        if(yaml_parser_parse(&parser, &event)) {
            done = (event.type == YAML_STREAM_END_EVENT);
            yaml_event_delete(&event);
        } else {
            sawError = YES;
            done = YES;
        }
    }
    
    yaml_parser_delete(&parser);
    
    STAssertFalse(sawError, nil);
}

- (void)testFloatScalarArchiving
{
    NSArray *testArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:(float)M_PI], 
                          [NSNumber numberWithDouble:M_PI], 
                          [NSNumber numberWithFloat:MAXFLOAT], 
                          [NSNumber numberWithDouble:INFINITY], 
                          [NSNumber numberWithDouble:-INFINITY], 
                          [NSNumber numberWithDouble:NAN], 
                          (__bridge NSNumber *)kCFNumberPositiveInfinity, 
                          (__bridge NSNumber *)kCFNumberNegativeInfinity, 
                          (__bridge NSNumber *)kCFNumberNaN, 
                          nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testArray];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    // A strict isEqual between the test array and the unarchived array doesn't
    // return YES, because the floats can't round-trip through ASCII properly
    // fully.
    // We also lose some type information, because YAML doesn't explicitly
    // encode e.g. float vs. double.
    // Nevertheless, the values are good enough for use, as a comparison of
    // their string represenatation will show.
    //STAssertTrue([unarchivedArray isEqual:testArray], nil);
    STAssertTrue([[unarchivedArray valueForKey:@"stringValue"]
                                       isEqual:[testArray valueForKey:@"stringValue"]], nil);
}

- (void)testIntegerScalarArchiving
{
    NSArray *testArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithChar:CHAR_MAX], 
                          [NSNumber numberWithChar:CHAR_MIN], 
                          [NSNumber numberWithUnsignedChar:UCHAR_MAX], 
                          [NSNumber numberWithUnsignedChar:0], 
                          [NSNumber numberWithShort:SHRT_MAX], 
                          [NSNumber numberWithShort:SHRT_MIN], 
                          [NSNumber numberWithUnsignedShort:USHRT_MAX], 
                          [NSNumber numberWithUnsignedShort:0], 
                          [NSNumber numberWithInt:INT_MAX], 
                          [NSNumber numberWithInt:INT_MIN], 
                          [NSNumber numberWithUnsignedInt:UINT_MAX], 
                          [NSNumber numberWithUnsignedInt:0], 
                          [NSNumber numberWithInteger:NSIntegerMax], 
                          [NSNumber numberWithInteger:NSIntegerMin], 
                          [NSNumber numberWithLong:LONG_MAX], 
                          [NSNumber numberWithLong:LONG_MIN], 
                          [NSNumber numberWithUnsignedLong:ULONG_MAX], 
                          [NSNumber numberWithUnsignedLong:0],
                          [NSNumber numberWithUnsignedInteger:NSUIntegerMax], 
                          [NSNumber numberWithUnsignedInteger:0],
                          nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testArray];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedArray isEqual:testArray], nil);
}

- (void)testBooleanArchiving
{
    NSArray *testArray = [NSArray arrayWithObjects:
                          [NSNumber numberWithBool:YES],
                          [NSNumber numberWithBool:NO],
                          nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testArray];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedArray isEqual:testArray], nil);
}


- (void)testDataArchiving
{
    char bytes[] = 
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890"
        "123456789012345678901234567890123456789012345678901234567890";
    
    NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSData dataWithBytesNoCopy:bytes length:sizeof(bytes) freeWhenDone:NO],
                                    @"my data's key",
                                    nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testDictionary];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedDictionary isEqual:testDictionary], nil);
}

- (void)testBigStringArchiving
{
    NSString *string = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum";
    
    NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    string,
                                    @"my string's key",
                                    nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testDictionary];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedDictionary isEqual:testDictionary], nil);
}



- (void)testNullArchiving
{
    NSArray *testArray = [NSArray arrayWithObjects:@"one", [NSNull null], @"two", [NSNull null], nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testArray];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedArray isEqual:testArray], nil);
}


- (void)testSetArchiving
{
    NSSet *testSet = [NSSet setWithObjects:@"one", @"two", @"three", @"four", @"two", nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testSet];
    
    STAssertTrue(data.length != 0, nil);
}


- (void)testEmptyString
{
    NSArray *testArray = [NSArray arrayWithObjects:@"one", @"", @"", @"three", @"four", nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testArray];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedArray isEqual:testArray], nil);
}



- (void)testSimpleArrayArchiving
{
    NSArray *testArray = [NSArray arrayWithObjects:@"one", @"two", @"three with a space and a colon:", nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testArray];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedArray isEqual:testArray], nil);
}

- (void)testSimpleDictionaryArchiving
{
    NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"onekey",
                                    @"two", @"twokey",
                                    @"three", @"threekey",
                                    [NSArray arrayWithObjects:@"one", @"two", @"three", nil], @"fourKey",
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"one", @"onekey",
                                     @"two", @"twokey",
                                     @"three", @"threekey",
                                     [NSArray arrayWithObjects:@"one", @"two", @"three", nil], @"fourKey",
                                     nil], @"dict",
                                    [NSArray arrayWithObjects:@"array", nil], [NSArray arrayWithObjects:@"arrayThatIsAKey", nil],
                                    nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testDictionary];
    
    STAssertTrue(data.length != 0, nil);
        
    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedDictionary isEqual:testDictionary], nil);
}

- (void)testStringsVsScalars
{
    NSArray *testArray = [NSArray arrayWithObjects:
                          @"1", 
                          [NSNumber numberWithInt:1],
                          @"y",
                          @"true",
                          [NSNumber numberWithBool:YES],
                          nil];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:testArray];
    
    STAssertTrue(data.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([unarchivedArray isEqual:testArray], nil);
}


- (void)testNSArchiverChars
{
    NSMutableData *data = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    char *string = "hello world";
    [archiver encodeValueOfObjCType:"*" at:&string];
     
    [archiver finishEncoding];
    
     STAssertTrue(data.length != 0, nil);
     
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    char *newString = nil;
    [unarchiver decodeValueOfObjCType:"*" at:&newString];
    
    STAssertTrue(strcmp(string, newString) == 0, nil);
}


- (void)testChars
{
    NSMutableData *data = [NSMutableData data];
    
    YACYAMLKeyedArchiver *archiver = [[YACYAMLKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    char *string = "hello world";
    [archiver encodeValueOfObjCType:"*" at:&string];
    
    [archiver finishEncoding];
    
    STAssertTrue(data.length != 0, nil);
    
    YACYAMLKeyedUnarchiver *unarchiver = [[YACYAMLKeyedUnarchiver alloc] initForReadingWithData:data];
    
    char *newString = nil;
    [unarchiver decodeValueOfObjCType:"*" at:&newString];
    
    STAssertTrue(strcmp(string, newString) == 0, nil);
}
/*
- (void)testUIView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor redColor];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:view];
    
    STAssertTrue(data.length != 0, nil);
    
    UIView *unarchivedView = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([[YACYAMLKeyedArchiver archivedDataWithRootObject:unarchivedView] isEqualToData:data], nil);
}
*/
- (void)testUIButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"Tap Me" forState:UIControlStateNormal];
    
    NSData *data = [YACYAMLKeyedArchiver archivedDataWithRootObject:button];
    
    STAssertTrue(data.length != 0, nil);
    
    UIView *unarchivedView = [YACYAMLKeyedUnarchiver unarchiveObjectWithData:data];
    
    STAssertTrue([[YACYAMLKeyedArchiver archivedDataWithRootObject:unarchivedView] isEqualToData:data], nil);
}

- (void)testAnchorGeneration
{
    YACYAMLKeyedArchiver *archiver = [[YACYAMLKeyedArchiver alloc] initForWritingWithMutableData:nil];
    
    STAssertEqualObjects(@"a", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"b", [archiver generateAnchor], nil);
    
    for(int i = 0; i < 24; ++i) {
        [archiver generateAnchor];
    }
    
    STAssertEqualObjects(@"A", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"B", [archiver generateAnchor], nil);

    for(int i = 0; i < 24; ++i) {
        [archiver generateAnchor];
    }

    STAssertEqualObjects(@"aa", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"ab", [archiver generateAnchor], nil);

    for(int i = 0; i < 24; ++i) {
        [archiver generateAnchor];
    }
    
    STAssertEqualObjects(@"aA", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"aB", [archiver generateAnchor], nil);

    
    for(int i = 0; i < 24; ++i) {
        [archiver generateAnchor];
    }
    
    STAssertEqualObjects(@"ba", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"bb", [archiver generateAnchor], nil);

    for(int i = 0; i < 24; ++i) {
        [archiver generateAnchor];
    }
    
    STAssertEqualObjects(@"bA", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"bB", [archiver generateAnchor], nil);
    
    for(int j = 0; j < 52; ++j) {
        [archiver generateAnchor];
    }
    
    STAssertEqualObjects(@"cC", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"cD", [archiver generateAnchor], nil);
        
    for(int i = 0; i < 52; ++i) {
        for(int j = 0; j < 52; ++j) {
            [archiver generateAnchor];
        }
    }

    STAssertEqualObjects(@"adE", [archiver generateAnchor], nil);
    STAssertEqualObjects(@"adF", [archiver generateAnchor], nil);
}

- (void)testPositiveIntegerParsing
{
    NSString *integersYAML = 
        @"canonical: 685230\n"
        @"decimal: 685_230\n"
        @"octal: 02472256\n"
        @"hexadecimal: 0x_0A_74_AE\n"
        @"binary: 0b1010_0111_0100_1010_1110\n"
        @"sexagesimal: 190:20:30\n"
        @"canonicalPlus: +685230\n"
        @"decimalPlus: +685_230\n"
        @"octalPlus: +02472256\n"
        @"hexadecimalPlus: +0x_0A_74_AE\n"
        @"binaryPlus: +0b1010_0111_0100_1010_1110\n"
        @"sexagesimalPlus: +190:20:30\n";
    
    NSArray *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:integersYAML];
    
    for(NSNumber *number in [unarchivedDictionary objectEnumerator]) {
        STAssertEquals(((NSInteger)685230), [number integerValue], NULL);
    }
}

- (void)testNegativeIntegerParsing
{
    NSString *integersYAML = 
        @"canonical: -685230\n"
        @"decimal: -685_230\n"
        @"octal: -02472256\n"
        @"hexadecimal: -0x_0A_74_AE\n"
        @"binary: -0b1010_0111_0100_1010_1110\n"
        @"sexagesimal: -190:20:30\n";
    
    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:integersYAML];
    
    for(NSNumber *number in [unarchivedDictionary objectEnumerator]) {
        STAssertEquals(((NSInteger)-685230), [number integerValue], NULL);
    }
}

- (void)testPositiveFloatParsing
{
    NSString *floatsYAML = 
        @"canonical: 6.8523015e+5"
        @"exponentioal: 685.230_15e+03"
        @"fixed: 685_230.15"
        @"sexagesimal: 190:20:30.15";

    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:floatsYAML];
    
    for(NSNumber *number in [unarchivedDictionary objectEnumerator]) {
        STAssertEquals(685230.15, [number doubleValue], NULL);
    }
}

- (void)testNegativePositiveFloatParsing
{
    NSString *floatsYAML = 
        @"canonical: -6.8523015e+5"
        @"exponentioal: -685.230_15e+03"
        @"fixed: -685_230.15"
        @"sexagesimal: -190:20:30.15";
    
    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:floatsYAML];
    
    for(NSNumber *number in [unarchivedDictionary objectEnumerator]) {
        STAssertEquals(-685230.15, [number doubleValue], NULL);
    }
}

- (void)testSpecialFloatParsing
{
    NSString *floatsYAML = 
        @"infinity: .INF\n"
        @"positive infinity: +.INF\n"
        @"negative infinity: -.inf\n"
        @"not a number: .NaN\n";
    
    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:floatsYAML];

    STAssertTrue(isinf([[unarchivedDictionary objectForKey:@"infinity"] doubleValue]), nil);
    STAssertTrue([[unarchivedDictionary objectForKey:@"infinity"] doubleValue] > 0, nil);
    STAssertFalse([[unarchivedDictionary objectForKey:@"infinity"] doubleValue] < 0, nil);
    
    STAssertTrue(isinf([[unarchivedDictionary objectForKey:@"positive infinity"] doubleValue]), nil);
    STAssertTrue([[unarchivedDictionary objectForKey:@"positive infinity"] doubleValue] > 0, nil);
    STAssertFalse([[unarchivedDictionary objectForKey:@"positive infinity"] doubleValue] < 0, nil);

    STAssertTrue(isinf([[unarchivedDictionary objectForKey:@"negative infinity"] doubleValue]), nil);
    STAssertTrue([[unarchivedDictionary objectForKey:@"negative infinity"] doubleValue] < 0, nil);
    STAssertFalse([[unarchivedDictionary objectForKey:@"negative infinity"] doubleValue] > 0, nil);

    STAssertTrue(isnan([[unarchivedDictionary objectForKey:@"not a number"] doubleValue]), nil);
}

- (void)testBinaryParsing
{
    NSString *binaryYAML = 
        @"canonical: !!binary \"\\\n"
        @" R0lGODlhDAAMAIQAAP//9/X17unp5WZmZgAAAOfn515eXvPz7Y6OjuDg4J+fn5\\\n"
        @" OTk6enp56enmlpaWNjY6Ojo4SEhP/++f/++f/++f/++f/++f/++f/++f/++f/+\\\n"
        @" +f/++f/++f/++f/++f/++SH+Dk1hZGUgd2l0aCBHSU1QACwAAAAADAAMAAAFLC\\\n"
        @" AgjoEwnuNAFOhpEMTRiggcz4BNJHrv/zCFcLiwMWYNG84BwwEeECcgggoBADs=\"\n"
        @"generic: !!binary |\n"
        @" R0lGODlhDAAMAIQAAP//9/X17unp5WZmZgAAAOfn515eXvPz7Y6OjuDg4J+fn5\n"
        @" OTk6enp56enmlpaWNjY6Ojo4SEhP/++f/++f/++f/++f/++f/++f/++f/++f/+\n"
        @" +f/++f/++f/++f/++f/++SH+Dk1hZGUgd2l0aCBHSU1QACwAAAAADAAMAAAFLC\n"
        @" AgjoEwnuNAFOhpEMTRiggcz4BNJHrv/zCFcLiwMWYNG84BwwEeECcgggoBADs=\n"
        @"description:\n"
        @" The binary value above is a tiny arrow encoded as a gif image.\n";
    
    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:binaryYAML];

    STAssertTrue([[unarchivedDictionary objectForKey:@"canonical"] isEqual:[unarchivedDictionary objectForKey:@"generic"]], nil);

    STAssertNotNil([UIImage imageWithData:[unarchivedDictionary objectForKey:@"canonical"]], nil);
    STAssertNotNil([UIImage imageWithData:[unarchivedDictionary objectForKey:@"generic"]], nil);
}

- (void)testNullParsing
{
    NSString *yaml = 
        @"empty:\n"
        @"canonical: ~\n"
        @"english: null\n"
        @"~: null key\n";

    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];
    
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"empty"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"canonical"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"english"], nil);
    STAssertEqualObjects(@"null key", [unarchivedDictionary objectForKey:[NSNull null]], nil);
}


- (void)testDateParsing
{
    NSString *yaml = 
    @"canonical:           2001-12-15T02:59:43.1Z\n"
    @"valid iso8601:       2001-12-14t21:59:43.10-05:00\n"
    @"space separated:     2001-12-14 21:59:43.10 -5\n"
    @"no time zone (Z):    2001-12-15 2:59:43.10\n"
    @"half hour time zone: 2001-12-15 3:29:43.10+00:30\n"
    @"date (00:00:00Z):    2002-12-14";
    
    NSDictionary *unarchivedDictionary = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];
    
    for(NSNumber *number in [[[unarchivedDictionary objectEnumerator] allObjects] valueForKey:@"timeIntervalSince1970"]) {
        STAssertTrue(number.doubleValue == 1008385183.1 || // 2001-12-15 2:59:43.10
                     number.doubleValue == 1039824000,     // 2002-12-14
                     nil);
    }
}   

- (void)testDateArchiving
{
    NSArray *testArray = [NSArray arrayWithObjects:[NSDate dateWithTimeIntervalSince1970:1039824000],
                                                   [NSDate dateWithTimeIntervalSince1970:1008385183.1],
                                                    nil];
    
    NSString *string = [YACYAMLKeyedArchiver archivedStringWithRootObject:testArray];
    
    STAssertTrue(string.length != 0, nil);
    
    NSArray *unarchivedArray = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:string];
    
    for(NSNumber *number in [unarchivedArray  valueForKey:@"timeIntervalSince1970"]) {
        STAssertTrue(number.doubleValue == 1008385183.1 || // 2001-12-15 2:59:43.10
                     number.doubleValue == 1039824000,     // 2002-12-14
                     nil);
    }
}


- (void)testMergeParsing
{
    NSString *yaml = 
    @"---\n"
    @"- &CENTER { x: 1, y: 2 }\n"
    @"- &LEFT { x: 0, y: 2 }\n"
    @"- &BIG { r: 10 }\n"
    @"- &SMALL { r: 1 }\n"
    @"\n"
    @"# All the following maps are equal:\n"
    @"\n"
    @"- # Explicit keys\n"
    @"  x: 1\n"
    @"  y: 2\n"
    @"  r: 10\n"
    @"  label: center/big\n"
    @"\n"
    @"- # Merge one map\n"
    @"  << : *CENTER\n"
    @"  r: 10\n"
    @"  label: center/big\n"
    @"\n"
    @"- # Merge multiple maps\n"
    @"  << : [ *CENTER, *BIG ]\n"
    @"  label: center/big\n"
    @"\n"
    @"- # Override\n"
    @"  << : [ *BIG, *LEFT, *SMALL ]\n"
    @"  x: 1\n"
    @"  label: center/big\n";
    
    NSArray *unarchived = [YACYAMLKeyedUnarchiver unarchiveObjectWithString:yaml];

    STAssertTrue(unarchived.count != 0, nil);
}

- (void)testYAMLExtensions
{
    NSString *yaml = 
    @"empty:\n"
    @"canonical: ~\n"
    @"english: null\n"
    @"~: null key\n";
    
    NSDictionary *unarchivedDictionary = [yaml YACYAMLDecode];
    
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"empty"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"canonical"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"english"], nil);
    STAssertEqualObjects(@"null key", [unarchivedDictionary objectForKey:[NSNull null]], nil);
    
    unarchivedDictionary = [yaml YACYAMLDecodeBasic];
    
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"empty"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"canonical"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"english"], nil);
    STAssertEqualObjects(@"null key", [unarchivedDictionary objectForKey:[NSNull null]], nil);
    
    unarchivedDictionary = [yaml YACYAMLDecodeAll];
    
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"empty"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"canonical"], nil);
    STAssertEqualObjects([NSNull null], [unarchivedDictionary objectForKey:@"english"], nil);
    STAssertEqualObjects(@"null key", [unarchivedDictionary objectForKey:[NSNull null]], nil);

}


@end
