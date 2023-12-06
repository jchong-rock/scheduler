//
//  SchedulerTests.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef SchedulerTests_h
#define SchedulerTests_h

@interface SchedulerTests : NSObject

- (BOOL) schedulerDoesRoundRobinScheduling;
- (BOOL) schedulerAllowsOverriding;
- (BOOL) schedulerTruncatesToDates;

@end

#endif /* SchedulerTests_h */
