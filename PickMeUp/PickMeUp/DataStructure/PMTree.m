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

/**
 * Internal function for recursivly finding a specific node in the tree
 * @param endString is the desired prefix for the returned node to contain
 * @param startNode is the node under whcich the function will search (often times is root node)
 * @return the node in the tree with a matching prefix to the one provided or node whose prefix is the longest sunstring if no node contains provided prefix
 */
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

/**
 * Function called to add a conversation as the payload of a node into the tree
 * @param toAdd conversation to be added to the tree
 * @see _traverseToNode and _insertNodes
 */
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

/**
 * Internal method for recursivly adding a node as a child, if the prefix of node to add is more than one char longer that the current node, will make empty ones
 * until the prefix of the current node matches and is one char shorter than the one to add
 *  @param toAdd the node being inserted into the tree
 *  @param username the prefix of the node being added
 *  @param currNode the existing node with a closest prefix to the one toAdd
 *  (the one who will either be toAdd's parent or from which empty childeren will begin to be created)
 *  @see addConversation (the method this one is called from)
 */
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

/**
 * Method for creating an array of all conversations in nodes in the sub tree of a given node
 * Utilizes a Queue to retrieve list sorted first by length of conversation username then alphabetically within a certain length
 * @param prefix of the node that is the root of the sub tree to retrieve from
 * @return an array of conversations whose usernames are prefixed by the given prefix
 */
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

