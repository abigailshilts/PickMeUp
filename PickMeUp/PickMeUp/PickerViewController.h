//
//  PickerView.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PickerViewControllerDelegate
-(void)recieveSport:(NSString *)sport;
-(void)recieveIntensity:(NSString *)intensity;
@end

@interface PickerViewController : UIViewController
@property (nonatomic, weak) id<PickerViewControllerDelegate> delegate;
@property int isSport;
@end

NS_ASSUME_NONNULL_END
