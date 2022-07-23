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
@property (nonatomic, strong) PMConversation *payLoad;
-(void)setChild:(PMNode *)child;
-(NSArray<PMNode *> *)getChildren;
@end

#endif /* PMNode_h */
