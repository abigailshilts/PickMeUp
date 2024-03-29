//
//  EmbedTableViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PMEmbedTableViewControllerDelegate
-(NSArray<Post *> *)refreshData;
@end

@interface PMEmbedTableViewController : UIViewController
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (weak, nonatomic) UIViewController *parent;
@property (nonatomic, weak) id<PMEmbedTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
