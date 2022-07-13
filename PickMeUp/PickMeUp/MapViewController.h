//
//  MapViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/13/22.
//
#import <CoreLocation/CoreLocation.h>
#import "Post.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property int distance;
@property (strong, nonatomic) CLLocation *pointToSet;
@end

NS_ASSUME_NONNULL_END
