//
//  CreatPostViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//

#import "CreatePostViewController.h"
#import "Post.h"
#import "StringsList.h"
#import "PickerViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface CreatePostViewController () <PickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *intensityPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UIImageView *imgOpt;
@property (weak, nonatomic) IBOutlet UITextField *groupWhere;
@property (weak, nonatomic) IBOutlet UITextField *groupWhen;
@property (weak, nonatomic) IBOutlet UITextView *groupBio;
@property (strong, nonatomic) UIImage *imgToPost;
@property (strong, nonatomic) NSString *groupIntensity;
@property (strong, nonatomic) NSString *groupSport;
@property (strong, nonatomic) NSArray *intensity;
@property (strong, nonatomic) NSArray *sport;
@property (strong, nonatomic) PFGeoPoint *curLoc;



@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.imgOpt addGestureRecognizer:tapRecognizer];
    self.locationManager = [[CLLocationManager alloc] init];
    
}

-(void)recieveSport:(NSString *)sport {
    self.groupSport = sport;
}

-(void)recieveIntensity:(NSString *)intensity {
    self.groupIntensity = intensity;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    originalImage = [self resizeImage:originalImage withSize:CGSizeMake(580,580)];

    [self.imgOpt setImage:originalImage];
    self.imgToPost = originalImage;
    
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

- (IBAction)didTapPost:(id)sender {
    Post *toPost = [Post new];
    toPost.bio = self.groupBio.text;
    toPost.sport = self.groupSport;
    toPost.intensity = self.groupIntensity;
    toPost.groupWhere = self.groupWhere.text;
    toPost.groupWhen = self.groupWhen.text;
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:self.groupWhere.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            //TODO: add error for invlaid address
            NSLog(@"Error: %@", [error localizedDescription]);
            return;
        }
        
        // A location was generated, hooray!
        if (placemarks && [placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0]; // Our placemark
            
            self.curLoc = [PFGeoPoint geoPointWithLocation:placemark.location];
            toPost.curLoc = self.curLoc;
            
            [toPost postUserImage:self.imgToPost withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                NSLog(postedSuccess);
            }];
            //self.pointToSet = [[CLLocation alloc] initWithLatitude:-43.242534 longitude:-54.93662];
            //NSLog(@"Lat: %f, Long: %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        }
    }];
    

    //self.curLoc = [PFGeoPoint geoPointWithLocation:self.pointToSet];

    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chooseSportView"]) {
        PickerViewController *childViewController = (PickerViewController *) [segue destinationViewController];
        childViewController.isSport = 1;
        childViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"chooseIntensityView"]) {
        PickerViewController *childViewController = (PickerViewController *) [segue destinationViewController];
        childViewController.isSport = 0;
        childViewController.delegate = self;
    }
}


@end
