//
//  Conversation.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import "Parse/Parse.h"
#import "PMConversation.h"
#import "StringsList.h"

@implementation PMConversation
@dynamic user1;
@dynamic user2;

+ (nonnull NSString *)parseClassName {
    return kConversationClassName;
}

- (void)postConvo:(PFUser *)user otherUser:(PFUser *)otherUser
   withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    NSComparisonResult result = [user.username compare:otherUser.username];
    if (result == NSOrderedAscending) {
        self.user1 = user;
        self.user2 = otherUser;
    } else {
        self.user1 = otherUser;
        self.user2 = user;
    }
    
    [self saveInBackgroundWithBlock: completion];
}

@end
