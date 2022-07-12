//
//  PostCellTableViewCell.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupImg;
@property (weak, nonatomic) IBOutlet UILabel *groupIntensity;
@property (weak, nonatomic) IBOutlet UILabel *groupSport;
@property (weak, nonatomic) IBOutlet UILabel *groupLocation;
@property (weak, nonatomic) IBOutlet UILabel *groupTime;
@property Post *post;
-(void) setPost;
-(void) setMyPost;
@end

NS_ASSUME_NONNULL_END