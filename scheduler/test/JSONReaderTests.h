//
//  JSONReaderTests.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef JSONReaderTests_h
#define JSONReaderTests_h

@interface JSONReaderTests : NSObject

- (instancetype) initWithInputPath:(NSString *) inputPath;

- (BOOL) jsonReaderDoesReadCorrectlyFormattedSchedule;
- (BOOL) jsonReaderDoesNotReadMalformedSchedule;
- (BOOL) jsonReaderDoesNotReadNonexistantSchedule;

- (BOOL) jsonReaderDoesReturnUsersFromSchedule;
- (BOOL) jsonReaderDoesReturnStartFromSchedule;
- (BOOL) jsonReaderDoesReturnPeriodFromSchedule;

- (BOOL) jsonReaderDoesReadCorrectlyFormattedOverrides;
- (BOOL) jsonReaderDoesReturnOverridesForUserWithOverrides;
- (BOOL) jsonReaderDoesReturnNullForUserWithoutOverrides;

@end

#endif /* JSONReaderTests_h */
