//
//  PMDMCell.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMDMCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *content;
-(void)prepareForReuse;
-(void)configureWithUser:(PFUser *)sender;
@end

NS_ASSUME_NONNULL_END
