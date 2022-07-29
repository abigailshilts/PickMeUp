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
@property (nonatomic, copy) void (^completionBlock)(NSArray<PMConversation *> *);
@end

@implementation PMDataManager

+ (id)dataManager {
    static PMDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    return dataManager;
}

-(void)fillConversations:(void(^)(NSArray<PMConversation *> *))completionBlock {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.completionBlock = completionBlock;
        self.conversations = [PMCachingFunctions retreiveConversationCache];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completionBlock == nil) {
                return;
            }
            self.completionBlock(self.conversations);
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
            /* Making this check because there likely won't be new conversations between different
            times accessing this VC */
            if (convos.count > self.conversations.count) {
                NSMutableArray<PMConversation *> *toUpdateWith = [NSMutableArray new];
                for (int i = 0; i < convos.count-self.conversations.count; i++) {
                    [toUpdateWith addObject:convos[i]];
                }
                self.conversations = convos;
                [PMCachingFunctions updateConversationCache:self.conversations];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    // Only returning new conversations so that the tree doesn't have to be recreated or have doubles
                    if (self.completionBlock == nil) {
                        return;
                    }
                    self.completionBlock(toUpdateWith);
                });
            }
        }
    }];
}

@end
