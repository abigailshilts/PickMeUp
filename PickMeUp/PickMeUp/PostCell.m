//
//  PostCellTableViewCell.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import "PostCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// find way to combine these two
-(void) setPost {
    self.groupIntensity.text = self.post.intensity;
    self.groupSport.text = self.post.sport;
    self.groupLocation.text = self.post.groupWhere;
    self.groupTime.text = self.post.groupWhen;
    
    NSString *link = self.post.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.groupImg setImageWithURL:url];
}

-(void) setMyPost {
    self.myGroupIntensity.text = self.post.intensity;
    self.myGroupSport.text = self.post.sport;
    self.myGroupLocation.text = self.post.groupWhere;
    self.myGroupTime.text = self.post.groupWhen;
    
    NSString *link = self.post.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.myGroupImg setImageWithURL:url];
}

@end
