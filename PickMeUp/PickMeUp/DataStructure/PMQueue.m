//
//  PMQueue.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/22/22.
//

#import <Foundation/Foundation.h>
#import "PMNode.h"
#import "PMQueue.h"

@interface PMQueue ()
@property (nonatomic, strong) NSMutableArray<PMNode *> *baseArr;
@end

@implementation PMQueue

-(PMQueue *)init {
    self.baseArr = [NSMutableArray new];
    return self;
}

-(void)enqueue:(PMNode *)toAdd {
    [self.baseArr addObject:toAdd];
}

-(PMNode *)dequeue {
    PMNode *toReturn = self.baseArr[0];
    [self.baseArr removeObjectAtIndex:0];
    return toReturn;
}

-(NSUInteger)arrayLength {
    return self.baseArr.count;
}
@end

