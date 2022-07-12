//
//  PickerView.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import "PMPickerViewController.h"

@interface PMPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *intensity;
@property (strong, nonatomic) NSArray *sport;
@end

@implementation PMPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.intensity = [NSArray arrayWithObjects: @"low", @"medium", @"high", @"any", nil];
    self.sport = [NSArray arrayWithObjects: @"Any", @"Soccer", @"Hockey", @"Football", @"Baseball/Softball", @"Frisbee", @"Spikeball", @"Volleyball", @"Other", nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.isSport == 0){
        return 4;
    } else {
        return 9;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    if (self.isSport == 0){
        title = self.intensity[row];
    } else {
        title = self.sport[row];
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isSport == 0){
        [self.delegate recieveIntensity:self.intensity[row]];
    } else {
        [self.delegate recieveSport:self.sport[row]];
    }

}

@end
