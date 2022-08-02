//
//  PMGMCell.h
//  PickMeUp
//
//  Created by Abigail Shilts on 8/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMGMCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *message;
-(void)configureWithUser:(PFUser *)sender;
@end

NS_ASSUME_NONNULL_END
