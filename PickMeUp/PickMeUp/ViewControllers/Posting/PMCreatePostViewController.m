//
//  CreatPostViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//

#import <CoreLocation/CoreLocation.h>
#import "PMCreatePostViewController.h"
#import "PMPickerViewController.h"
#import "Post.h"
#import "StringsList.h"

@interface PMCreatePostViewController () <PickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
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
static const NSString *const kErrPostingImgString = @"Error Posting Photo";
static const NSString *const kErrPostingImgMessage =
    @"There appears to be an error savin this post, check your internet and try again";

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
    originalImage = [self _resizeImage:originalImage withSize:CGSizeMake(580,580)];
    self.imgToPost = originalImage;
    
    // changes img on view controller to one seleted
    [self.imgOpt setImage:originalImage];
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

- (IBAction)didTapPost:(id)sender {
    self.myButton.enabled = NO;
    Post *toPost = [Post new];
    toPost.bio = self.groupBio.text;
    toPost.sport = self.groupSport;
    toPost.intensity = self.groupIntensity;
    toPost.groupWhere = self.groupWhere.text;
    toPost.groupWhen = self.groupWhen.text;
    toPost.isEvent = @"no";
    
    
    // turns street adress into coordinates
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:self.groupWhere.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            //TODO: add error for invlaid address
            NSLog(kErrMsgString, [error localizedDescription]);
            return;
        }
        
        // A location was generated
        if (placemarks && [placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0]; // Our placemark
            
            // creates geoPoint (for parse) from CLLocation
            self.curLoc = [PFGeoPoint geoPointWithLocation:placemark.location];
            toPost.curLoc = self.curLoc;
            toPost.latitude = placemark.location.coordinate.latitude;
            toPost.longitude = placemark.location.coordinate.longitude;
            
            [toPost postUserImage:self.imgToPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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
