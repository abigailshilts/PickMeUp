//
//  PMDMCell.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//
#import "Parse/Parse.h"
#import "PMDMCell.h"

@implementation PMDMCell

-(void)prepareForReuse {
    [super prepareForReuse];
    self.content.backgroundColor = [UIColor clearColor];
    self.content.textAlignment=NSTextAlignmentLeft;
}

-(void)configureWithUser:(PFUser *)sender {
    if ([sender.username isEqual:PFUser.currentUser.username]){
        self.content.textAlignment=NSTextAlignmentRight;
    } else {
        self.content.backgroundColor = [UIColor systemMintColor];
    }
}
@end
