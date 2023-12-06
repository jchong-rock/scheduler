//
//  JSONReader.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "JSONReader.h"
#import "User.h"
#import "DateUtils.h"

#define USERS_TAG @"users"
#define PERIOD_TAG @"handover_interval_days"
#define START_TAG @"handover_start_at"


@interface JSONReader () {
    NSMutableDictionary<User *, NSMutableArray<Timeslot *> *> * overrides;
    NSArray<User *> * users;
    NSNumber * period;
    NSDate * start;
}

- (id) JSONFromFile:(NSString *) path;

@end

@implementation JSONReader

- (instancetype) init {
    self = [super init];
    overrides = [[NSMutableDictionary alloc] init];
    return self;
}

- (id) JSONFromFile:(NSString *) path {
    NSData * jsonData = [NSData dataWithContentsOfFile: path];
    if (jsonData == nil) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData: jsonData options: kNilOptions error: nil];
}

- (BOOL) readOverrides:(NSString *) path {
    NSArray<NSDictionary *> * data = [self JSONFromFile: path];
    if (data == nil) {
        return NO;
    }
    for (NSDictionary * dict in data) {
        User * user = [dict objectForKey: USER_TAG];
        NSDate * startTime = [DateUtils readDate: [dict objectForKey: START_AT_TAG]];
        NSDate * endTime = [DateUtils readDate: [dict objectForKey: END_AT_TAG]];
        
        if (startTime == nil || user == nil || endTime == nil) {
            return NO;
        }
        
        Timeslot * timeslot = [[Timeslot alloc] initWithStart: startTime andEnd: endTime];
        
        if (timeslot == nil) {
            return NO;
        }
        
        if ([overrides objectForKey: user] == nil) {
            [overrides setObject: [[NSMutableArray alloc] init] forKey: user];
        }
        [[overrides objectForKey: user] addObject: timeslot];
    }
    
    return YES;
}

- (BOOL) readSchedule:(NSString *) path {
    NSDictionary * data = [self JSONFromFile: path];
    if (data == nil) {
        return NO;
    }
    users = [data objectForKey: USERS_TAG];
    period = [data objectForKey: PERIOD_TAG];
    start = [DateUtils readDate: [data objectForKey: START_TAG]];
    if (start == nil || users == nil || period == nil) {
        return NO;
    }
    return YES;
}

- (NSArray<Timeslot *> *) overridesForUser:(User *) user {
    return [overrides objectForKey: user];
}

- (NSInteger) period {
    return [period intValue];
}

- (NSDate *) start {
    return start;
}

- (NSArray<User *> *) users {
    return users;
}

@end
