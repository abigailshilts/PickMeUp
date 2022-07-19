//
//  PMDMCell.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import "PMDMCell.h"

@implementation PMDMCell
-(void)prepareForReuse {
    [super prepareForReuse];
    self.content.backgroundColor = [UIColor clearColor];
    self.content.textAlignment=NSTextAlignmentLeft;
}
@end
