//
//  Timeslot.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef Timeslot_h
#define Timeslot_h

#import "User.h"

@interface Timeslot : NSObject

@property (retain, nonatomic, readonly) NSDate * start;
@property (retain, nonatomic, readonly) NSDate * end;

- (instancetype) initWithStart:(NSDate *) start andEnd:(NSDate *) end;

+ (NSArray<Timeslot *> *) truncateIfTimeslot:(Timeslot *) o overlapsWith:(Timeslot *) n;

@end


#endif /* Timeslot_h */
