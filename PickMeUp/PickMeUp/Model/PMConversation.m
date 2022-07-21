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
@dynamic sender;
@dynamic receiver;

+ (nonnull NSString *)parseClassName {
    return kConversationClassName;
}

- (void)postConvo:(PFBooleanResultBlock  _Nullable)completion {
    [self saveInBackgroundWithBlock:completion];
}

@end
