//
//  DetailsView.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@class PMPost;

NS_ASSUME_NONNULL_BEGIN

@interface PMDetailsViewController : UIViewController
@property (strong, nonatomic) PMPost *post;
@end

NS_ASSUME_NONNULL_END
