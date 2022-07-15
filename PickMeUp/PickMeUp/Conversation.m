//
//  Conversation.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import "Conversation.h"
#import "Parse/Parse.h"

@implementation Conversation
@dynamic user1;
@dynamic user2;

+ (nonnull NSString *)parseClassName {
    return @"Conversation";
}

- (void)postConvo:(PFUser *)user otherUser:(PFUser *)otherUser withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    NSComparisonResult result = [user.username compare:otherUser.username];
    if (result == NSOrderedAscending) {
        self.user1 = user;
        self.user2 = otherUser;
    }
    else {
        self.user1 = otherUser;
        self.user2 = user;
    }
    
    [self saveInBackgroundWithBlock: completion];
}

@end
