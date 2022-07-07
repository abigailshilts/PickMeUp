//
//  PostCellTableViewCell.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupImg;
@property (weak, nonatomic) IBOutlet UIImageView *myGroupImg;
@property (weak, nonatomic) IBOutlet UILabel *groupIntensity;
@property (weak, nonatomic) IBOutlet UILabel *myGroupIntensity;
@property (weak, nonatomic) IBOutlet UILabel *groupSport;
@property (weak, nonatomic) IBOutlet UILabel *myGroupSport;
@property (weak, nonatomic) IBOutlet UILabel *groupLocation;
@property (weak, nonatomic) IBOutlet UILabel *myGroupLocation;
@property (weak, nonatomic) IBOutlet UILabel *groupTime;
@property (weak, nonatomic) IBOutlet UILabel *myGroupTime;
@property Post *post;
-(void) setPost;
-(void) setMyPost;
@end

NS_ASSUME_NONNULL_END
