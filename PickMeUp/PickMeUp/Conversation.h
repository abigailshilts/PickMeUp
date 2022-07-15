//
//  Conversation.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface Conversation : PFObject<PFSubclassing>
@property (nonatomic, strong) PFUser *user1;
@property (nonatomic, strong) PFUser *user2;
- (void)postConvo:(PFUser *)user otherUser:(PFUser *)otherUser withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
