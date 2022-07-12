//
//  EmbedTableViewController.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMEmbedTableViewController : UIViewController
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@end

NS_ASSUME_NONNULL_END
