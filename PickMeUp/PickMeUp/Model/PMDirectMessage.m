//
//  DirectMessage.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/13/22.
//
#import "Parse/Parse.h"
#import "PMDirectMessage.h"

@implementation PMDirectMessage
@dynamic content;
@dynamic convoId;
@dynamic sender;

+ (nonnull NSString *)parseClassName {
    return kDirectMessageClassName;
}

- (void)postDM: (PFBooleanResultBlock  _Nullable)completion {
    [self saveInBackgroundWithBlock: completion];
}

@end

