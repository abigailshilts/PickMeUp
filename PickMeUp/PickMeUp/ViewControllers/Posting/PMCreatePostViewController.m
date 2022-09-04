//
//  CreatPostViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//

#import <CoreLocation/CoreLocation.h>
#import "PMCreatePostViewController.h"
#import "PMPickerViewController.h"
#import "PickMeUp-Swift.h"
#import "PMReuseFunctions.h"
#import "Post.h"
#import "StringsList.h"

@interface PMCreatePostViewController () <PickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgOpt;
@property (weak, nonatomic) IBOutlet UITextField *groupWhere;
@property (weak, nonatomic) IBOutlet UITextField *groupWhen;
@property (weak, nonatomic) IBOutlet UITextView *groupBio;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (strong, nonatomic) UIImage *imgToPost;
@property (strong, nonatomic) NSString *groupIntensity;
@property (strong, nonatomic) NSString *groupSport;
@property (strong, nonatomic) NSArray *intensity;
@property (strong, nonatomic) NSArray *sport;
@property (strong, nonatomic) PFGeoPoint *curLoc;

@end

@implementation PMCreatePostViewController

static const NSString *const kChooseIntensityViewSegue = @"chooseIntensityView";
static const NSString *const kChooseSportViewSegue = @"chooseSportView";
static const int kImgSize = 580;

- (void)viewDidLoad {
    [super viewDidLoad];
    // gesture so tapping img photo pulls up library
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.imgOpt addGestureRecognizer:tapRecognizer];
    self.groupBio.delegate = self;
    self.groupWhen.delegate = self;
    self.groupWhere.delegate = self;
}

- (BOOL)_textFieldShouldReturn:(UITextField *)textField {
   [textField resignFirstResponder];
   return true;
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }

    [txtView resignFirstResponder];
    return NO;
}

// delegate methods for recieving picker info
-(void)didReceiveSport:(NSString *)sport {
    self.groupSport = sport;
}

-(void)didReceiveIntensity:(NSString *)intensity {
    self.groupIntensity = intensity;
}

// pulls up library when img is tapped
- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    originalImage = [PMReuseFunctions resizeImage:originalImage withSize:CGSizeMake(kImgSize,kImgSize)];
    self.imgToPost = originalImage;
    
    // changes img on view controller to one seleted
    [self.imgOpt setImage:originalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapPost:(id)sender {
    self.myButton.enabled = NO;
    // turns street adress into coordinates
    CLGeocoder *geocoder = [CLGeocoder new];
    [PMReuseFunctions savePostWithLocation:geocoder address:self.groupWhere.text bio:self.groupBio.text sport:self.groupSport intensity:self.groupIntensity groupWhen:self.groupWhen.text isEvent:kIsntEventString withImage:self.imgToPost];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kChooseSportViewSegue]) {
        PMPickerViewController *childViewController = (PMPickerViewController *) [segue destinationViewController];
        childViewController.isSport = YES;
        childViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:kChooseIntensityViewSegue]) {
        PMPickerViewController *childViewController = (PMPickerViewController *) [segue destinationViewController];
        childViewController.isSport = NO;
        childViewController.delegate = self;
    }
}


@end
