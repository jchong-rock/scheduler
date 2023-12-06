//
//  JSONReaderTests.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"
#import "Assert.h"
#import "JSONReaderTests.h"
#import "JSONReader.h"

@interface JSONReaderTests () {
    NSString * inputPath;
}

@end

@implementation JSONReaderTests

- (instancetype) initWithInputPath:(NSString *) ip {
    self = [super init];
    inputPath = ip;
    return self;
}

- (BOOL) jsonReaderDoesReadCorrectlyFormattedSchedule {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@goodSchedule.json", inputPath];
    return [jsonReader readSchedule: filePath];
}

- (BOOL) jsonReaderDoesNotReadMalformedSchedule {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@badSchedule.json", inputPath];
    return ![jsonReader readSchedule: filePath];
}

- (BOOL) jsonReaderDoesNotReadNonexistantSchedule {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"doesntExist" ofType:@"json"];
    return ![jsonReader readSchedule: filePath];
}

- (BOOL) jsonReaderDoesReturnUsersFromSchedule {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@goodSchedule.json", inputPath];
    Assert(([jsonReader readSchedule: filePath]));
    
    NSArray * expectedArray = @[@"alice", @"bob", @"charlie"];
    Assert(([[jsonReader users] isEqualToArray: expectedArray]));
    return YES;
}

- (BOOL) jsonReaderDoesReturnStartFromSchedule {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@goodSchedule.json", inputPath];
    Assert(([jsonReader readSchedule: filePath]));
    
    NSDate * expectedStart = [[NSDate alloc] initWithTimeIntervalSince1970: 1700240400];
    Assert(([expectedStart isEqualToDate: [jsonReader start]]));
    return YES;
}

- (BOOL) jsonReaderDoesReturnPeriodFromSchedule {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@goodSchedule.json", inputPath];
    Assert(([jsonReader readSchedule: filePath]));
    
    NSInteger expectedPeriod = 7;
    Assert((expectedPeriod == [jsonReader period]));
    return YES;
}

- (BOOL) jsonReaderDoesReadCorrectlyFormattedOverrides {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@goodOverrides.json", inputPath];
    return [jsonReader readOverrides: filePath];
}

- (BOOL) jsonReaderDoesReturnOverridesForUserWithOverrides {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@goodOverrides.json", inputPath];
    Assert(([jsonReader readOverrides: filePath]));
    
    User * user = @"charlie";
    NSDate * expectedStart = [[NSDate alloc] initWithTimeIntervalSince1970: 1700499600];
    NSDate * expectedEnd = [[NSDate alloc] initWithTimeIntervalSince1970: 1700503200];
    Timeslot * expectedTimeslot = [[Timeslot alloc] initWithStart: expectedStart andEnd: expectedEnd];
    NSArray<Timeslot *> * timeslots = @[expectedTimeslot];
    
    Assert(([timeslots isEqualToArray: [jsonReader overridesForUser: user]]));
    return YES;
    
}

- (BOOL) jsonReaderDoesReturnNullForUserWithoutOverrides {
    JSONReader * jsonReader = [[JSONReader alloc] init];
    NSString * filePath = [NSString stringWithFormat:@"%@goodOverrides.json", inputPath];
    Assert(([jsonReader readOverrides: filePath]));
    
    User * user = @"bob";
    Assert(([jsonReader overridesForUser: user] == nil));
    return YES;
}


@end
