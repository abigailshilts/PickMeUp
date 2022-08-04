//
//  PMCreateEventViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 8/1/22.
//
#import <CoreLocation/CoreLocation.h>
#import "PMCreateEventViewController.h"
#import "PMReuseFunctions.h"
#import "Post.h"
#import "StringsList.h"

@interface PMCreateEventViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UITextField *eventWhen;
@property (strong, nonatomic) IBOutlet UITextField *eventWhere;
@property (strong, nonatomic) IBOutlet UITextView *eventDescription;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) UIImage *imgToPost;
@end

@implementation PMCreateEventViewController

static const NSString *const kErrPostingImgString = @"Error Posting Photo";
static const NSString *const kErrPostingImgMessage =
    @"There appears to be an error savin this post, check your internet and try again";
static const int kImgSize = 580;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *didTapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAction:)];
    didTapImg.numberOfTapsRequired = 1;
    [self.img addGestureRecognizer:didTapImg];
    
    self.eventWhen.delegate = self;
    self.eventWhere.delegate = self;
}

- (BOOL)_textFieldShouldReturn:(UITextField *)textField {
   [textField resignFirstResponder];
   return true;
}

// pulls up library when img is tapped
- (void)didTapAction:(UITapGestureRecognizer *)tap {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    originalImage = [PMReuseFunctions resizeImage:originalImage withSize:CGSizeMake(kImgSize,kImgSize)];
    self.imgToPost = originalImage;
    
    // changes img on view controller to one seleted
    [self.img setImage:originalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCreate:(id)sender {
    self.createButton.enabled = NO;
    Post *toCreate = [Post new];
    toCreate.bio = self.eventDescription.text;
    toCreate.groupWhen = self.eventWhen.text;
    toCreate.groupWhere = self.eventWhere.text;
    toCreate.isEvent = kIsEventString;
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [PMReuseFunctions savePostWithLocation:toCreate geoCoder:geocoder address:self.eventWhere.text withImage:self.imgToPost];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
