//
//  MapViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/13/22.
//
#import "Post.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMMapViewController : UIViewController
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property int distance;
@property (strong, nonatomic) CLLocation *pointToSet;
@end

NS_ASSUME_NONNULL_END
