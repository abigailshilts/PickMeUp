//
//  PMTree.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "PMNode.h"
#import "PMTree.h"
#import "PMQueue.h"
#import "StringsList.h"

@interface PMTree ()
@end

@implementation PMTree

-(PMTree *)init {
    self.rootNode = [PMNode new];
    self.rootNode.prefix = kEmpt;
    return self;
}

-(PMNode *)_traverseToNode:(NSString *)endString withStartNode:(PMNode *)startNode {
    if ([startNode.prefix isEqualToString:endString]) {
        return startNode;
    }
    
    NSString *subToFind = [endString substringToIndex:([startNode.prefix length]+1)];
    for (PMNode *childNode in [startNode getChildren]) {
        if ([childNode.prefix isEqualToString:subToFind]) {
            return [self _traverseToNode:endString withStartNode:childNode];
        }
    }
    
    return startNode;
}

-(void)addConversation:(PMConversation *)toAdd {
    NSString *name;
    
    [toAdd.sender fetchIfNeeded];
    [toAdd.receiver fetchIfNeeded];
    if ([toAdd.sender.username isEqual:PFUser.currentUser.username]) {
        name = toAdd.receiver.username;
    } else {
        name = toAdd.sender.username;
    }
    
    PMNode *start = [self _traverseToNode:name withStartNode:self.rootNode];
    if ([name isEqualToString:start.prefix]) {
        start.payLoad = toAdd;
        return;
    }
    PMNode *adding = [PMNode new];
    adding.prefix = name;
    adding.payLoad = toAdd;
    [self _insertNodes:adding username:name currentNode:start];
    return;
}

-(void)_insertNodes:(PMNode *)toAdd username:(NSString *)username currentNode:(PMNode *)currNode {
    
    if ([currNode.prefix length] == [username length]-1) {
        [currNode setChild:toAdd];
        return;
    } else {
        PMNode *emptNode = [PMNode new];
        emptNode.prefix = [username substringToIndex:[currNode.prefix length]+1];
        [currNode setChild:emptNode];
        [self _insertNodes:toAdd username:username currentNode:emptNode];
        return;
    }
}

-(NSArray<PMConversation *> *)retrieveSubTree:(NSString *)prefix {
    PMNode *start = [self _traverseToNode:prefix withStartNode:self.rootNode];
    if ([start.prefix length] != [prefix length]) {
        return nil;
    }
    PMQueue *queue = [PMQueue new];
    NSMutableArray<PMConversation *> *toReturn = [NSMutableArray new];
    
    [queue enqueue:start];
    while ([queue count] != 0) {
        PMNode *current = [queue dequeue];
        for (PMNode *child in [current getChildren]) {
            [queue enqueue:child];
        }
        if (current.payLoad != nil) {
            [toReturn addObject:current.payLoad];
        }
    }
    return toReturn;
}
@end

