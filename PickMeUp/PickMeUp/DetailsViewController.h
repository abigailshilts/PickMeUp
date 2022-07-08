//
//  DetailsView.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
