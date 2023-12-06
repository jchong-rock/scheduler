//
//  DateUtils.h
//  scheduler
//
//  Created by Jake Chong on 28/11/2023.
//

#ifndef DateUtils_h
#define DateUtils_h

#define INTERVAL_FOR_DAYS(days) days*86400;

@class Schedule;

@interface DateUtils : NSObject

+ (NSDate *) readDate:(NSString *) date;
+ (NSString *) printDate:(NSDate *) date;
+ (NSString *) printSchedule:(Schedule *) schedule;

@end

#endif /* DateUtils_h */
