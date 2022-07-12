//
//  PostCellTableViewCell.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import "PMPostCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@implementation PMPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setPost {
    self.groupIntensity.text = self.post.intensity;
    self.groupSport.text = self.post.sport;
    self.groupLocation.text = self.post.groupWhere;
    self.groupTime.text = self.post.groupWhen;
    
    NSString *link = self.post.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.groupImg setImageWithURL:url];
}


@end
