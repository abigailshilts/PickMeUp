//
//  PickerView.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import "PMPickerViewController.h"

@interface PMPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray<NSString *> *intensity;
@property (strong, nonatomic) NSArray<NSString *> *sport;
@end

@implementation PMPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.intensity = [NSArray arrayWithObjects: @"any", @"low", @"medium", @"high", nil];
    self.sport = [NSArray arrayWithObjects: @"Any", @"Soccer", @"Hockey", @"Football", @"Baseball/Softball",
                  @"Frisbee", @"Spikeball", @"Volleyball", @"Other", nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.isSport == NO){
        return self.intensity.count;
    } else {
        return self.sport.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    if (self.isSport == NO){
        title = [self.intensity[row] capitalizedString];
    } else {
        title = self.sport[row];
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.isSport == NO){
        [self.delegate didReceiveIntensity:self.intensity[row]];
    } else {
        [self.delegate didReceiveSport:self.sport[row]];
    }

}

@end
