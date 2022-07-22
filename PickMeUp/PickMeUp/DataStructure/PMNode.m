//
//  PMNode.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "PMNode.h"

@interface PMNode ()
@property (nonatomic, strong) NSMutableArray<PMNode *> *children;
@end

@implementation PMNode

-(void)setChild:(PMNode *)child {
    if (self.children == nil){
        self.children = [NSMutableArray new];
        [self.children addObject:child];
    } else {
        // adds child to place in alphabetically sorted list
        for (int i = 0; i < self.children.count; i++) {
            NSComparisonResult result = [child.prefix compare:self.children[i].prefix];
            if (result == NSOrderedAscending) {
                [self.children insertObject:child atIndex:i];
                break;
            } else if (i == (self.children.count -1)) {
                [self.children addObject:child];
                break;
            }
        }
    }
}

-(NSArray<PMNode *> *)getChildren {
    return self.children;
}

@end
