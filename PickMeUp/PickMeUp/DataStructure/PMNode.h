//
//  PMNode.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "PMConversation.h"

#ifndef PMNode_h
#define PMNode_h

@interface PMNode : NSObject
@property (nonatomic, strong) NSString *prefix;
-(void)setPayLoad:(PMConversation *)convo;
-(void)setChild:(PMNode *)child;
-(PMConversation *)getPayLoad;
-(NSArray<PMNode *> *)getChildren;
@end

#endif /* PMNode_h */
