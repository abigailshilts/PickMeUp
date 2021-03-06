//
//  PostCellTableViewCell.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//


#import "Post.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const NSString *const kPostCellClassName = @"PMPostCell";

@interface PMPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupImg;
@property (weak, nonatomic) IBOutlet UILabel *groupIntensity;
@property (weak, nonatomic) IBOutlet UILabel *groupSport;
@property (weak, nonatomic) IBOutlet UILabel *groupLocation;
@property (weak, nonatomic) IBOutlet UILabel *groupTime;
-(void) setPost:(Post *)post;
@end

NS_ASSUME_NONNULL_END
