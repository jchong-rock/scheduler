//
//  Assert.h
//  scheduler
//
//  Created by Jake Chong on 27/11/2023.
//

#ifndef Assert_h
#define Assert_h

#define Assert(statement) if (!statement) {\
                            NSLog(@"%@ :: assertion %s failed.", NSStringFromSelector(_cmd), #statement);\
                            return NO;\
                          }

#endif /* Assert_h */
