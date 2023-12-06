//
//  Scheduler.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef Scheduler_h
#define Scheduler_h

#import "User.h"
#import "Timeslot.h"
#import "Schedule.h"

@interface Scheduler : NSObject

- (instancetype) initWithStart:(NSDate *) s andEnd:(NSDate *) e;
- (void) roundRobinWithUsers:(NSArray<User *> *) users andPeriod:(NSInteger) period andStart:(NSDate *) s;
- (void) scheduleOverrides:(NSArray<Timeslot *> *) overrides forUser:(User *) user;
- (Schedule *) getSchedule;

@end


#endif /* Scheduler_h */
