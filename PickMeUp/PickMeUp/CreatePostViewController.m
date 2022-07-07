//
//  CreatPostViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//

#import "CreatePostViewController.h"
#import "Post.h"
#import "StringsList.h"


@interface CreatePostViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *intensityPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UIImageView *imgOpt;
@property (weak, nonatomic) IBOutlet UITextView *groupWhere;
@property (weak, nonatomic) IBOutlet UITextView *groupWhen;
@property (weak, nonatomic) IBOutlet UITextView *groupBio;
@property (strong, nonatomic) UIImage *imgToPost;
@property (strong, nonatomic) NSString *groupIntensity;
@property (strong, nonatomic) NSString *groupSport;




@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.intensityPicker.delegate = self;
    self.intensityPicker.dataSource = self;
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.imgOpt addGestureRecognizer:tapRecognizer];

}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    originalImage = [self resizeImage:originalImage withSize:CGSizeMake(580,580)];

    // Do something with the images (based on your use case)
    [self.imgOpt setImage:originalImage];
    self.imgToPost = originalImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
        self.groupIntensity = title;
    } else {
        title = sport[row];
        self.groupSport = title;
    }


    
    return title;
}

- (IBAction)didTapPost:(id)sender {
    Post *toPost = [Post new];
    toPost.bio = self.groupBio.text;
    toPost.sport = self.groupSport;
    toPost.intensity = self.groupIntensity;
    toPost.groupWhere = self.groupWhere.text;
    toPost.groupWhen = self.groupWhen.text;
    
    [toPost postUserImage:self.imgToPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(postedSuccess);
    }];
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
