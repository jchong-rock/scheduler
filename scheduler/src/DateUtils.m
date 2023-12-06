//
//  DateUtils.m
//  scheduler
//
//  Created by Jake Chong on 28/11/2023.
//

#import <Foundation/Foundation.h>
#import "DateUtils.h"
#import "Schedule.h"

@implementation DateUtils

+ (NSDate *) readDate:(NSString *) date {
    if (date == nil) {
        return nil;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation: @"UTC"]];
    return [dateFormatter dateFromString: date];
}

+ (NSString *) printDate:(NSDate *) date {
    if (date == nil) {
        return nil;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation: @"UTC"]];
    return [dateFormatter stringFromDate: date];
}

+ (NSString *) printSchedule:(Schedule *) schedule {
    id result = [schedule getSchedule];
    if (result == nil) {
        return @"";
    }
    NSData * json = [NSJSONSerialization dataWithJSONObject: result options: NSJSONWritingPrettyPrinted error: nil];
    return [[NSString alloc] initWithData: json encoding: NSUTF8StringEncoding];
}

@end
