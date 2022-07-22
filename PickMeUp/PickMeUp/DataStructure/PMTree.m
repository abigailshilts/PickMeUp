//
//  PMTree.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "PMNode.h"
#import "PMTree.h"
#import "StringsList.h"

@interface PMTree ()
@end

@implementation PMTree

-(PMTree *)init {
    self.rootNode = [PMNode new];
    self.rootNode.prefix = kEmpt;
    return self;
}

-(PMNode *)traverseToNode:(NSString *)endString withstartNode:(PMNode *)startNode {
    if ([startNode.prefix isEqualToString:endString]) {
        return startNode;
    }
    
    NSString *subToFind = [endString substringToIndex:([startNode.prefix length]+1)];
    for (PMNode *childNode in [startNode getChildren]){
        if ([childNode.prefix isEqualToString:subToFind]) {
            return [self traverseToNode:endString withstartNode:childNode];
        }
    }
    
    return startNode;
}

@end
