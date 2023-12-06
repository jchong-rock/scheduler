//
//  main.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "ScheduleTests.h"
#import "Tester.h"
#import "JSONReaderTests.h"
#import "Scheduler.h"
#import "JSONReader.h"
#import "FileReader.h"
#import "DateUtils.h"
#import "SchedulerTests.h"

int test(char const * inputPath) {
    int result = 0;
    @autoreleasepool {
        NSArray * testClasses = @[@"ScheduleTests", @"SchedulerTests"];
        
        for (NSString * class in testClasses) {
            id testClass = NSClassFromString(class);
            id test = [[testClass alloc] init];
            result += runTests(test);
        }
        JSONReaderTests * jsonReaderTests = [[JSONReaderTests alloc] initWithInputPath: @(inputPath)];
        result += runTests(jsonReaderTests);
    }
    return result;
}

int run(char const * schedule, char const * overrides, char const * start, char const * end) {
    @autoreleasepool {
        NSObject<FileReader> * fileReader = [[JSONReader alloc] init];
        
        NSString * sch = [@(schedule) stringByReplacingOccurrencesOfString: @"'" withString: @""];
        if (![fileReader readSchedule: sch]) {
            fprintf(stderr, "Error reading schedule '%s'\n", schedule);
            return 1;
        }
        
        NSString * ovr = [@(overrides) stringByReplacingOccurrencesOfString: @"'" withString: @""];
        if (![fileReader readOverrides: ovr]) {
            fprintf(stderr, "Error reading overrides '%s'\n", overrides);
            return 2;
        }
        
        NSString * srt = [@(start) stringByReplacingOccurrencesOfString: @"'" withString: @""];
        NSDate * startTime = [DateUtils readDate: srt];
        if (startTime == nil) {
            fprintf(stderr, "Invalid start date '%s'\n", start);
            return 3;
        }
        
        NSString * e = [@(end) stringByReplacingOccurrencesOfString: @"'" withString: @""];
        NSDate * endTime = [DateUtils readDate: e];
        if (endTime == nil) {
            fprintf(stderr, "Invalid end date '%s'\n", end);
            return 4;
        }

        Scheduler * scheduler = [[Scheduler alloc] initWithStart: startTime andEnd: endTime];
        NSArray<User *> * users = [fileReader users];
        NSInteger period = [fileReader period];
        NSDate * s = [fileReader start];
        
        [scheduler roundRobinWithUsers: users andPeriod: period andStart: s];
        for (User * u in users) {
            id overrides = [fileReader overridesForUser: u];
            [scheduler scheduleOverrides: overrides forUser: u];
        }
        
        Schedule * sc = [scheduler getSchedule];
        NSString * result = [DateUtils printSchedule: sc];
        if (result == nil) {
            NSLog(@"Invalid JSON '%@'\n", result);
            return 5;
        }
        printf("\n%s\n", [result UTF8String]);
    }
    return 0;
}

int main(int argc, const char * argv[]) {
    
    if (argc == 3 && strcmp("--test", argv[1]) == 0) {
        printf("Running tests...\n");
        return test(argv[2]);
    }
    
    if (argc == 5) {
        
        const char * delim = "=";
        
        char * schedule;
        char * overrides;
        char * start;
        char * end;
        
        char * token;
        short correct = 0;
        
        token = strtok(argv[1], delim);
        if (strcmp(token, "--schedule") == 0) {
            schedule = strtok(NULL, delim);
            correct++;
        }
        token = strtok(argv[2], delim);
        if (strcmp(token, "--overrides") == 0) {
            overrides = strtok(NULL, delim);
            correct++;
        }
        token = strtok(argv[3], delim);
        if (strcmp(token, "--from") == 0) {
            start = strtok(NULL, delim);
            correct++;
        }
        token = strtok(argv[4], delim);
        if (strcmp(token, "--until") == 0) {
            end = strtok(NULL, delim);
            correct++;
        }
        
        if (correct == 4) {
            return run(schedule, overrides, start, end);
        }
    }
    
    perror("Invalid arguments.\n");
    return -1;
}
