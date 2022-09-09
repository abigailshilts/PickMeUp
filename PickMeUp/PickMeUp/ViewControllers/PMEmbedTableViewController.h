//
//  EmbedTableViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@class PMPost;

NS_ASSUME_NONNULL_BEGIN

@protocol PMEmbedTableViewControllerDelegate
-(void)runQuery:(void(^)(NSArray<PMPost *> *))completionBlock;
@end

@interface PMEmbedTableViewController : UIViewController
@property (strong, nonatomic) NSArray<PMPost *> *arrayOfPosts;
@property (weak, nonatomic) UIViewController *parent;
@property (strong, nonatomic) NSString *isMy;
@property (strong, nonatomic) NSString *sport;
@property (strong, nonatomic) NSString *intensity;
@property (strong, nonatomic) NSString *dist;
@property (strong, nonatomic) CLLocation *loc;
@property (nonatomic, weak) id<PMEmbedTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
