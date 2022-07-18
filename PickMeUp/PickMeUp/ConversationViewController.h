//
//  ConversationViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Conversation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConversationViewController : UIViewController
@property (nonatomic, strong) PFUser *reciever;
@property (nonatomic, strong) Conversation *convo;
@end

NS_ASSUME_NONNULL_END
