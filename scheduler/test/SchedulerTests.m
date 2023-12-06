//
//  SchedulerTests.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "Scheduler.h"
#import "Schedule.h"
#import "Assert.h"
#import "SchedulerTests.h"
#import "DateUtils.h"

@implementation SchedulerTests

- (BOOL) schedulerDoesRoundRobinScheduling {
    NSInteger tenDays = INTERVAL_FOR_DAYS(10);
    NSDate * start = [[NSDate alloc] initWithTimeIntervalSince1970: tenDays];
    NSDate * end = [[NSDate alloc] initWithTimeIntervalSince1970: 5 * tenDays];
    Scheduler * scheduler = [[Scheduler alloc] initWithStart: start andEnd: end];
    
    [scheduler roundRobinWithUsers: @[@"jake", @"katya", @"kagan"] andPeriod: 10 andStart: start];
    
    Schedule * schedule = [scheduler getSchedule];
    
    Assert([[schedule getScheduleForUser: @"jake"][0] isEqual: [[Timeslot alloc] initWithStart: start andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 2 * tenDays]]]);
    Assert([[schedule getScheduleForUser: @"katya"][0] isEqual: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 2 * tenDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 3 * tenDays]]]);
    Assert([[schedule getScheduleForUser: @"kagan"][0] isEqual: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 3 * tenDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 4 * tenDays]]]);
    Assert([[schedule getScheduleForUser: @"jake"][1] isEqual: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 4 * tenDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 5 * tenDays]]]);
    
    return YES;
}

- (BOOL) schedulerTruncatesToDates {
    NSInteger fiveDays = INTERVAL_FOR_DAYS(5);
    NSInteger tenDays = INTERVAL_FOR_DAYS(10);
    NSDate * start = [[NSDate alloc] initWithTimeIntervalSince1970: tenDays];
    NSDate * end = [[NSDate alloc] initWithTimeIntervalSince1970: 5 * tenDays];
    NSDate * s = [[NSDate alloc] initWithTimeIntervalSince1970: fiveDays];
    Scheduler * scheduler = [[Scheduler alloc] initWithStart: start andEnd: end];
    
    [scheduler roundRobinWithUsers: @[@"jake", @"katya", @"kagan"] andPeriod: 10 andStart: s];
    
    Schedule * schedule = [scheduler getSchedule];
    
    Assert([[schedule getScheduleForUser: @"kagan"][0] isEqual: [[Timeslot alloc] initWithStart: start andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 3 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"jake"][0] isEqual: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 3 * fiveDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 5 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"katya"][0] isEqual: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 5 * fiveDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 7 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"kagan"][1] isEqual: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 7 * fiveDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 9 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"jake"][1] isEqual: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 9 * fiveDays] andEnd: end]]);
    
    return YES;
}



- (BOOL) schedulerAllowsOverriding {
    NSInteger fiveDays = INTERVAL_FOR_DAYS(5);
    NSInteger tenDays = INTERVAL_FOR_DAYS(10);
    NSDate * start = [[NSDate alloc] initWithTimeIntervalSince1970: tenDays];
    NSDate * end = [[NSDate alloc] initWithTimeIntervalSince1970: 5 * tenDays];
    Scheduler * scheduler = [[Scheduler alloc] initWithStart: start andEnd: end];
    
    [scheduler roundRobinWithUsers: @[@"jake", @"katya", @"kagan"] andPeriod: 10 andStart: start];
    
    NSDate * s = [[NSDate alloc] initWithTimeIntervalSince1970: 3 * fiveDays];
    NSDate * e = [[NSDate alloc] initWithTimeIntervalSince1970: 5 * fiveDays];
    
    [scheduler scheduleOverrides:@[[[Timeslot alloc] initWithStart: s andEnd: e]] forUser: @"kagan"];
    
    Schedule * schedule = [scheduler getSchedule];
    
    Assert([[schedule getScheduleForUser: @"jake"] containsObject: [[Timeslot alloc] initWithStart: start andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 3 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"kagan"] containsObject: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 3 * fiveDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 5 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"katya"] containsObject: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 5 * fiveDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 6 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"kagan"] containsObject: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 6 * fiveDays] andEnd: [[NSDate alloc] initWithTimeIntervalSince1970: 8 * fiveDays]]]);
    Assert([[schedule getScheduleForUser: @"jake"] containsObject: [[Timeslot alloc] initWithStart: [[NSDate alloc] initWithTimeIntervalSince1970: 8 * fiveDays] andEnd: end]]);
    
    return YES;
}

@end
