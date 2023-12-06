//
//  ScheduleTests.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"
#import "Assert.h"
#import "ScheduleTests.h"

@implementation ScheduleTests

// This is an example of a functional test case.
// Use XCTAssert and related functions to verify your tests produce the correct results.
- (BOOL) scheduleDoesRetainAddedTime {
    User * user = @"bob";
    Schedule * schedule = [[Schedule alloc] init];
    
    NSDate * start = [[NSDate alloc] initWithTimeIntervalSince1970: 200];
    NSDate * end = [[NSDate alloc] initWithTimeIntervalSince1970: 400];
    
    [schedule scheduleUser: user toStartAt: start andEndAt: end];
    Timeslot * slot = [[schedule getScheduleForUser: user] objectAtIndex: 0];
    
    Assert((slot.start == start));
    Assert((slot.end == end));
    return YES;
}

- (BOOL) overridingTimeDoesTruncateOldAllocation {
    User * user1 = @"katya";
    User * user2 = @"jake";
    Schedule * schedule = [[Schedule alloc] init];
    
    NSDate * start = [[NSDate alloc] initWithTimeIntervalSince1970: 200];
    NSDate * end = [[NSDate alloc] initWithTimeIntervalSince1970: 4000];
    
    NSDate * startOverride = [[NSDate alloc] initWithTimeIntervalSince1970: 300];
    NSDate * endOverride = [[NSDate alloc] initWithTimeIntervalSince1970: 500];
    
    [schedule scheduleUser: user1 toStartAt: start andEndAt: end];
    [schedule scheduleUser: user2 toStartAt: startOverride andEndAt: endOverride];
    
    id scheduleUser1 = [schedule getScheduleForUser: user1];
    Assert(([scheduleUser1 count] == 2));
    
    
    Timeslot * slot1 = [[schedule getScheduleForUser: user1] objectAtIndex: 0];
    Timeslot * slot2 = [[schedule getScheduleForUser: user1] objectAtIndex: 1];
    
    Assert((slot1.start == start));
    Assert((slot1.end == startOverride));
    Assert((slot2.start == endOverride));
    Assert((slot2.end == end));
    return YES;
}


- (BOOL) scheduleDoesReturnEmptyListForUnknownUser {
    User * user = @"bob";
    Schedule * schedule = [[Schedule alloc] init];
    
    NSArray<Timeslot *> * timeslots = [schedule getScheduleForUser: user];
    
    Assert(([timeslots count] == 0));
    return YES;
}

@end
