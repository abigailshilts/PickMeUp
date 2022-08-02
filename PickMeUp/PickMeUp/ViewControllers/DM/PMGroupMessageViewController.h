//
//  GroupMessageViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 8/2/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMGroupMessageViewController : UIViewController
@property (strong, nonatomic) Post *event;
@end

NS_ASSUME_NONNULL_END
