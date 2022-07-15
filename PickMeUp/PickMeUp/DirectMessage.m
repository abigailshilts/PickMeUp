//
//  DirectMessage.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/13/22.
//

#import "DirectMessage.h"
#import "Parse/Parse.h"

@implementation DirectMessage
@dynamic content;
@dynamic convoId;

+ (nonnull NSString *)parseClassName {
    return @"DirectMessage";
}

- (void)postDM: (PFBooleanResultBlock  _Nullable)completion {
    [self saveInBackgroundWithBlock: completion];
}

@end

