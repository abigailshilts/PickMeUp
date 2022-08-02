//
//  PMCreateEventViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 8/1/22.
//
#import <CoreLocation/CoreLocation.h>
#import "PMCreateEventViewController.h"
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
    originalImage = [self _resizeImage:originalImage withSize:CGSizeMake(580,580)];
    self.imgToPost = originalImage;
    
    // changes img on view controller to one seleted
    [self.img setImage:originalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (IBAction)didTapCreate:(id)sender {
    self.createButton.enabled = NO;
    Post *toCreate = [Post new];
    toCreate.bio = self.eventDescription.text;
    toCreate.groupWhen = self.eventWhen.text;
    toCreate.groupWhere = self.eventWhere.text;
    toCreate.isEvent = kIsEventString;
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:self.eventWhere.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(kErrMsgString, [error localizedDescription]);
            return;
        }
        
        // A location was generated
        if (placemarks && [placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0]; // Our placemark
            
            // creates geoPoint (for parse) from CLLocation
            toCreate.curLoc = [PFGeoPoint geoPointWithLocation:placemark.location];
            
            [toCreate postUserImage:self.imgToPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kErrPostingImgString message:kErrPostingImgMessage preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkString style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * _Nonnull action) {}];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:^{}];
                } else {
                    NSLog(kPostedSuccessString);
                }
            }];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
