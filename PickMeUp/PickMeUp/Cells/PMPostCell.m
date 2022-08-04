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

static const NSString *const kEventString = @"Event!!!!";

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setPost:(Post *)post {
    [post fetchIfNeeded];
    if ([post.isEvent isEqualToString:kIsntEventString]) {
        self.groupIntensity.text = post.intensity;
        self.groupSport.text = post.sport;
        self.groupLocation.text = post.groupWhere;
        self.groupTime.text = post.groupWhen;
    } else {
        self.groupIntensity.text = kEventString;
        self.groupSport.text = post.groupWhen;
        self.groupLocation.text = post.groupWhere;
        self.groupTime.hidden = YES;
    }
    NSString *link = post.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.groupImg setImageWithURL:url];
}


@end
