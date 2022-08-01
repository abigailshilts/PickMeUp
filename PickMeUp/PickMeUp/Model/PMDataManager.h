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
-(void)fillConversations:(nullable void(^)(NSArray<PMConversation *> *))completionBlock;
-(void)fillDMs:(PMConversation *)convo withBlock:(void(^)(NSArray<PMDirectMessage *> *))block;
-(void)saveDMs:(NSArray<PMDirectMessage *> *)toSave conversation:(PMConversation *)convo;
-(void)loadMoreDMs:(PMConversation *)convo pageCount:(NSInteger)pageCount
          withBlock:(void(^)(NSArray<PMDirectMessage *> *))completionBlock;
+ (id)dataManager;
@end

NS_ASSUME_NONNULL_END
