//
//  PickerView.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "PMSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PickerViewControllerDelegate
-(void)didReceiveSport:(NSString *)sport;
-(void)didReceiveIntensity:(NSString *)intensity;
@end

@interface PMPickerViewController : UIViewController
@property (nonatomic, weak) id<PickerViewControllerDelegate> delegate;
@property BOOL isSport;
@end

NS_ASSUME_NONNULL_END
