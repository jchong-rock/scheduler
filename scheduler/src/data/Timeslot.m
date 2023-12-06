//
//  Timeslot.m
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#import <Foundation/Foundation.h>
#import "Timeslot.h"

@implementation Timeslot

- (instancetype) initWithStart:(NSDate *) start andEnd:(NSDate *) end {
    self = [super init];
    _start = start;
    _end = end;
    return self;
}

- (BOOL) isEqual:(id) object {
    if (![object isKindOfClass: [self class]]) {
        return NO;
    }
    Timeslot * toCompare = (Timeslot *) object;
    return ([self.start isEqualToDate: toCompare.start] && [self.end isEqualToDate: toCompare.end]);
}

- (NSUInteger) hash {
    return ([self.start hash] ^ [self.end hash]);
}

- (NSString *) description {
    NSTimeInterval s = [self.start timeIntervalSince1970];
    NSTimeInterval e = [self.end timeIntervalSince1970];
    return [NSString stringWithFormat: @"Timeslot(%f : %f)", s, e];
}

+ (NSArray<Timeslot *> *) truncateIfTimeslot:(Timeslot *) old overlapsWith:(Timeslot *) new {
    NSTimeInterval os =  [old.start timeIntervalSince1970];
    NSTimeInterval oe =  [old.end timeIntervalSince1970];
    NSTimeInterval ns =  [new.start timeIntervalSince1970];
    NSTimeInterval ne =  [new.end timeIntervalSince1970];
    
    if (oe <= ne && os >= ns) {
        return @[];
    }
    if ((ns < os && ne < oe && ns < oe && ne > os) || ([old.start isEqualToDate: new.start])) {
        return @[[[Timeslot alloc] initWithStart: new.end andEnd: old.end]];
    }
    if ((ns > os && ne > oe && ns < oe && ne > os) || ([old.end isEqualToDate: new.end])) {
        return @[[[Timeslot alloc] initWithStart: old.start andEnd: new.start]];
    }
    if (os < ns && oe > ne) {
        return @[
            [[Timeslot alloc] initWithStart: old.start andEnd: new.start],
            [[Timeslot alloc] initWithStart: new.end andEnd: old.end]
        ];
    }

    return @[old];
}

@end
