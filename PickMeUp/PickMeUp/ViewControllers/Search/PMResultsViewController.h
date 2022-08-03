//
//  ResultsViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMResultsViewController : UIViewController
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (strong, nonatomic) UIViewController *toSet;
@property int distance;
@property (strong, nonatomic) CLLocation *pointToSet;
@end

NS_ASSUME_NONNULL_END
