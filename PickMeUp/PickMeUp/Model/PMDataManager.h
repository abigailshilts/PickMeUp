//
//  PMDataManager.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/27/22.
//

#import <Foundation/Foundation.h>
#import "PMConversation.h"
#import "PMTree.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMDataManager : NSObject
@property (nonatomic, strong) NSArray<PMConversation*> *conversations;
-(void)fillConversations:(void(^)(NSArray<PMConversation *> *))block;
+ (id)dataManager;
@end

NS_ASSUME_NONNULL_END
