//
//  FileReader.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef FileReader_h
#define FileReader_h

#import <Foundation/Foundation.h>
#import "User.h"
#import "Timeslot.h"

@protocol FileReader

- (BOOL) readSchedule:(NSString *) path;
- (BOOL) readOverrides:(NSString *) path;

- (NSArray<User *> *) users;
- (NSArray<Timeslot *> *) overridesForUser:(User *) user;
- (NSInteger) period;
- (NSDate *) start;


@end


#endif /* FileReader_h */
