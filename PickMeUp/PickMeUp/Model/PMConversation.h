//
//  Conversation.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
NS_ASSUME_NONNULL_BEGIN

static const NSString *const kSenderKey = @"sender";
static const NSString *const kReceiverKey = @"receiver";
static const NSString *const kConversationClassName = @"Conversation";

@interface PMConversation : PFObject<PFSubclassing>
@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *receiver;
- (void)postConvo:(PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
