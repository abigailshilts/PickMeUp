//
//  SearchViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@class PMPost;

NS_ASSUME_NONNULL_BEGIN

@interface PMSearchViewController : UIViewController
-(void)recieveInfo:(NSString *)sport;
-(void)recieveIntensity:(NSString *)intensity;
-(NSArray<Post *> *)refreshData;
- (void)getQuery:(void(^)(NSArray<PMPost *> *))completionBlock;
@end

NS_ASSUME_NONNULL_END
