//
//  Schedule.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef Schedule_h
#define Schedule_h

#import "User.h"
#import "Timeslot.h"

@interface Schedule : NSObject

- (void) scheduleUser:(User *) user toStartAt:(NSDate *) start andEndAt:(NSDate *) end;
- (void) scheduleUser:(User *) user forTimeslot:(Timeslot *) timeslot;
- (NSArray<Timeslot *> *) getScheduleForUser:(User *) user;
- (NSArray<NSDictionary<NSString *, NSString *> *> *) getSchedule;

@end

#endif /* Schedule_h */
