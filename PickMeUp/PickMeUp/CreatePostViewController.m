//
//  CreatPostViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//

#import "CreatePostViewController.h"

@interface CreatePostViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *intensityPicker;

@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.intensityPicker.delegate = self;
    self.intensityPicker.dataSource = self;
    self.intensityPicker.showsSelectionIndicator = YES;
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    self.sportPicker.showsSelectionIndicator = YES;
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:self.intensityPicker]){
        return 3;
    } else {
        return 8;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    NSArray *intensity = [NSArray arrayWithObjects: @"low", @"medium", @"high", nil];
    NSArray *sport = [NSArray arrayWithObjects: @"Soccer", @"Hockey", @"Football", @"Baseball/Softball", @"Frisbee", @"Spikeball", @"Volleyball", @"Other", nil];
    if ([pickerView isEqual:self.intensityPicker]){
        title = intensity[row];
    } else {
        title = sport[row];
    }


    
    return title;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
