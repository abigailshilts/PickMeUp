//
//  MyPostsViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMMyPostsViewController : UIViewController
-(void)runQuery:(void(^)(NSArray<PMPost *> *))completionBlock;
@end

NS_ASSUME_NONNULL_END
