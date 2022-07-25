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

-(void) setPost:(Post *)post {
    [post fetchIfNeeded];
    self.groupIntensity.text = post.intensity;
    self.groupSport.text = post.sport;
    self.groupLocation.text = post.groupWhere;
    self.groupTime.text = post.groupWhen;
    
    NSString *link = post.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.groupImg setImageWithURL:url];
}


@end
