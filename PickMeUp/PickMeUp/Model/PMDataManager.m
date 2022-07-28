//
//  PMDataManager.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/27/22.
//
#import "Parse/Parse.h"
#import "PMCachingFunctions.h"
#import "PMDataManager.h"
#import "PMTree.h"
#import "StringsList.h"

@interface PMDataManager ()
@property (nonatomic, copy) void (^block)(NSArray<PMConversation *> *);
@end

@implementation PMDataManager

-(void)fillConversations:(void(^)(NSArray<PMConversation *> *))block {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.block = block;
        self.conversations = [PMCachingFunctions retreiveConversationCache];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.block(self.conversations);
        });
        [self _runGetQuery];
    });
}

-(void)_runGetQuery {
    PFUser *currentUser = PFUser.currentUser;
    // Populates conversation array
    // builds query to search for currentUser in either user1 or user2
    PFQuery *user1 = [PFQuery queryWithClassName:kConversationClassName];
    [user1 whereKey:kSenderKey equalTo:currentUser];
    PFQuery *user2 = [PFQuery queryWithClassName:kConversationClassName];
    [user2 whereKey:kReceiverKey equalTo:currentUser];
    PFQuery *toQuery = [PFQuery orQueryWithSubqueries:@[user1, user2]];
    [toQuery findObjectsInBackgroundWithBlock:^(NSArray *convos, NSError *error) {
        if (convos != nil) {
            if (convos.count > self.conversations.count) {
                NSMutableArray<PMConversation *> *toUpdateWith = [NSMutableArray new];
                for (int i = 0; i < convos.count-self.conversations.count; i++) {
                    [toUpdateWith addObject:convos[i]];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.block(toUpdateWith);
                });
                self.conversations = convos;
                [PMCachingFunctions updateConversationCache:self.conversations];
            }
        }
    }];
}

@end
