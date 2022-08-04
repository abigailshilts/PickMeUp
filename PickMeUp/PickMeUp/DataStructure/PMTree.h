//
//  PMTree.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/21/22.
//
#import <Foundation/Foundation.h>
#import "PMNode.h"

#ifndef PMTree_h
#define PMTree_h
@interface PMTree: NSObject
@property (nonatomic, strong) PMNode *rootNode;
-(PMTree *)init;
-(void)addConversation:(PMConversation *)toAdd;
-(NSArray<PMConversation *> *)retrieveSubTree:(NSString *)prefix;
@end
#endif /* PMTree_h */
