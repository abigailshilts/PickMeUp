//
//  DirectMessage.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/13/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface DirectMessage : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *convoId;
- (void)postDM: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
