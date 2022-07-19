//
//  ConversationViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//
#import "PMConversation.h"
#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMConversationViewController : UIViewController
@property (nonatomic, strong) PFUser *receiver;
@property (nonatomic, strong) PMConversation *convo;
@end

NS_ASSUME_NONNULL_END
