//
//  Scheduler.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "Scheduler.h"
#import "Schedule.h"
#import "DateUtils.h"

#include "math.h"

@interface Scheduler () {
    NSDate * start;
    NSDate * end;
    Schedule * schedule;
    Timeslot * exclusion;
}

@end

@implementation Scheduler

- (instancetype) initWithStart:(NSDate *) s andEnd:(NSDate *) e {
    self = [super init];
    start = s;
    end = e;
    schedule = [[Schedule alloc] init];
    exclusion = [[Timeslot alloc] initWithStart: end andEnd: start];
    return self;
}

// schedule in round robin
- (void) roundRobinWithUsers:(NSArray<User *> *) users andPeriod:(NSInteger) period andStart:(NSDate *) s {
    const NSTimeInterval periodInterval = INTERVAL_FOR_DAYS(period);
    NSTimeInterval currentTimeStamp = [s timeIntervalSince1970];
    const NSTimeInterval startStamp = [start timeIntervalSince1970];
    if (startStamp > currentTimeStamp) {
        NSInteger jumps = ceilf((startStamp - currentTimeStamp) / periodInterval);
        currentTimeStamp += jumps * periodInterval;
        NSDate * endpoint = [[NSDate alloc] initWithTimeIntervalSince1970: currentTimeStamp];
        [schedule scheduleUser: [users lastObject] toStartAt: start andEndAt: endpoint];
        
    }
    BOOL filling = YES;
    while (filling) {
        for (User * user in users) {
            NSTimeInterval nextTimeStamp = currentTimeStamp + periodInterval;
            NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSince1970: currentTimeStamp];
            filling = (nextTimeStamp < [end timeIntervalSince1970]);
            NSDate * nextDate = (filling) ? [[NSDate alloc] initWithTimeIntervalSince1970: nextTimeStamp] : end;
            
            [schedule scheduleUser: user toStartAt: currentDate andEndAt: nextDate];
            currentTimeStamp = nextTimeStamp;
            if (!filling) {
                break;
            }
        }
    }
}

- (void) scheduleOverrides:(NSArray<Timeslot *> *) overrides forUser:(User *) user {
    for (Timeslot * t in overrides) {
        NSDate * currentStart = t.start;
        NSDate * currentEnd = t.end;
        if ([currentStart timeIntervalSince1970] < [start timeIntervalSince1970]) {
            currentStart = start;
        }
        if ([currentEnd timeIntervalSince1970] > [end timeIntervalSince1970]) {
            currentEnd = end;
        }

        [schedule scheduleUser: user forTimeslot: [[Timeslot alloc] initWithStart: currentStart andEnd: currentEnd]];

    }
}
 
- (Schedule *) getSchedule {
    return schedule;
}


@end
