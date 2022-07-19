//
//  DirectMessage.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/13/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

static const NSString *const kDirectMessageClassName = @"DirectMessage";

@interface PMDirectMessage : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *convoId;
@property (nonatomic, strong) PFUser *sender;
- (void)postDM: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
