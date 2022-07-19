//
//  Conversation.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
NS_ASSUME_NONNULL_BEGIN

static const NSString *const kUser1Key = @"user1";
static const NSString *const kUser2Key = @"user2";
static const NSString *const kConversationClassName = @"Conversation";

@interface PMConversation : PFObject<PFSubclassing>
@property (nonatomic, strong) PFUser *user1;
@property (nonatomic, strong) PFUser *user2;
- (void)postConvo:(PFUser *)user otherUser:(PFUser *)otherUser
   withCompletion:(PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
