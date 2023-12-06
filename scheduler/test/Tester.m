//
//  Tester.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int runTests(id testType) {
    int passed = 0;
    int result;
    @autoreleasepool {
        Class scheduleTestsClass = [testType class];
        
        unsigned int methodCount;
        unsigned int realMethodCount = 0;
        Method * methods = class_copyMethodList(scheduleTestsClass, &methodCount);

        for (unsigned int i = 0; i < methodCount; i++) {
            Method method = methods[i];
            SEL selector = method_getName(method);
            NSString * testName = NSStringFromSelector(selector);
            if ([testName hasPrefix: @"init"] || [testName hasPrefix: @"."]) {
                continue;
            }
            
            realMethodCount++;
            IMP imp = method_getImplementation(method);
            BOOL testResult = ((BOOL (*) (id, SEL)) imp) (testType, selector);
            NSString * didPass;
            
            if (testResult) {
                passed++;
                didPass = @"Passed";
            } else {
                didPass = @"Failed";
            }
            NSLog(@"%@ test %@", didPass, testName);
            
        }

        free(methods);
        result = (passed != realMethodCount);
        
        NSLog(@"Passed %d / %u tests", passed, realMethodCount);
    }
    return result;
}
