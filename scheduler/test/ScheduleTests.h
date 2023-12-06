//
//  ScheduleTests.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef ScheduleTests_h
#define ScheduleTests_h

@interface ScheduleTests : NSObject

- (BOOL) scheduleDoesRetainAddedTime;
- (BOOL) scheduleDoesReturnEmptyListForUnknownUser;
- (BOOL) overridingTimeDoesTruncateOldAllocation;

@end

#endif /* ScheduleTests_h */
