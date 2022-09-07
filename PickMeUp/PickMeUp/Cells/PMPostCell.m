//
//  PostCellTableViewCell.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//
#import "PickMeUp-Swift.h"
#import "PMPostCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
@import FirebaseCore;
@import FirebaseStorage;
@import FirebaseStorageUI;

@implementation PMPostCell

static const NSString *const kEventString = @"Event!!!!";

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.groupTime.hidden = NO;
    self.groupImg.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setPost:(PMPost *)post {
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
    UIImage *placeholderImage;
    [self.groupImg sd_setImageWithStorageReference:post.storageRef placeholderImage:placeholderImage];
}


@end
