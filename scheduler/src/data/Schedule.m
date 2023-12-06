//
//  Scheduler.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"
#import "DateUtils.h"

@interface Schedule () {
    NSMutableDictionary<User *, NSMutableArray<Timeslot *> *> * allocations;
}

@end

@implementation Schedule

- (instancetype) init {
    self = [super init];
    allocations = [[NSMutableDictionary alloc] init];
    return self;
}

- (void) scheduleUser:(User *) user toStartAt:(NSDate *) start andEndAt:(NSDate *) end {
    Timeslot * timeslot = [[Timeslot alloc] initWithStart: start andEnd: end];
    [self scheduleUser: user forTimeslot: timeslot];
}

- (void) scheduleUser:(User *) user forTimeslot:(Timeslot *) timeslot {
    // check for overlaps
    NSMutableDictionary * temp = [[NSMutableDictionary alloc] init];
    for (User * key in allocations) {
        NSArray * oldSlots = [allocations objectForKey: key];
        NSMutableArray * newSlots = [[NSMutableArray alloc] initWithArray: oldSlots];
        for (Timeslot * slot in oldSlots) {
            NSArray<Timeslot *> * truncated = [Timeslot truncateIfTimeslot: slot overlapsWith: timeslot];
            if ([truncated count] == 0 || ![truncated[0] isEqual: slot]) {
                [newSlots removeObject: slot];
                [newSlots addObjectsFromArray: truncated];
                break;
            }
        }
        [temp setObject: newSlots forKey: key];
    }
    
    allocations = temp;
    
    NSMutableArray * timeslots = [allocations objectForKey: user];
    if (timeslots == nil) {
        [allocations setObject: [[NSMutableArray alloc] initWithObjects: timeslot, nil] forKey: user];
    } else {
        [timeslots addObject: timeslot];
    }
}

- (NSArray<Timeslot *> *) getScheduleForUser:(User *) user {
    return [allocations objectForKey: user];
}

- (NSArray<NSDictionary<NSString *, NSString *> *> *) getSchedule {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (User * key in allocations) {
        NSArray<Timeslot *> * timeslots = [allocations objectForKey: key];
        for (Timeslot * slot in timeslots) {
            [array addObject: @{
                USER_TAG : key,
                START_AT_TAG : [DateUtils printDate: slot.start],
                END_AT_TAG : [DateUtils printDate: slot.end]
            }];
        }
    }
    return array;
}

- (NSString *) description {
    return [allocations description];
}

@end
