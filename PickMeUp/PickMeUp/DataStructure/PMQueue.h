//
//  PMQueue.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/22/22.
//

#ifndef PMQueue_h
#define PMQueue_h

@interface PMQueue: NSObject
-(void)enqueue:(PMNode *)toAdd;
-(NSUInteger)count;
-(PMNode *)dequeue;
@end
#endif /* PMQueue_h */
