//
//  SearchViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//
#import <CoreLocation/CoreLocation.h>
#import "MapKit/MapKit.h"
#import "Parse/Parse.h"
#import "PMPickerViewController.h"
#import "PMResultsViewController.h"
#import "PMSearchViewController.h"
#import "Post.h"
#import "SceneDelegate.h"
#import "StringsList.h"

@interface PMSearchViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *distanceChoice;
@property (weak, nonatomic) IBOutlet UIView *sportContainer;
@property (strong, nonatomic) NSString *groupIntensity;
@property (strong, nonatomic) NSString *groupSport;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *pointToSet;
@property (strong, nonatomic) CLLocation *pointReceived;
@property (strong, nonatomic) PFGeoPoint *curLoc;

@end

@implementation PMSearchViewController

static const NSString *const kGoToFeedSegue = @"goToFeed";
static const NSString *const kSportViewSegue = @"sportView";
static const NSString *const kIntensityViewSegue = @"intensityView";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.distanceChoice.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   [textField resignFirstResponder];
   return true;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
   self.pointToSet = [locations lastObject];
}

- (IBAction)didTapLogout:(id)sender {
    // Sends to login screen
    SceneDelegate *mySceneDelegate = (SceneDelegate * )
        UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainString bundle:nil];
    UIViewController *loginViewController =
        [storyboard instantiateViewControllerWithIdentifier:kLogViewControllerClassName];
    mySceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil){
            // TODO: add alert
        }
    }];
}

// delegate methods for recieving pickerview user input
-(void)didReceiveSport:(NSString *)sport {
    self.groupSport = sport;
}

-(void)didReceiveIntensity:(NSString *)intensity {
    self.groupIntensity = intensity;
}

- (IBAction)didTapGo:(id)sender {
    [self.locationManager stopUpdatingLocation];
    self.distance = self.distanceChoice.text;
    [self runQuery];
}

- (void)runQuery {
    // TODO: add alert for not filled in distance
    self.curLoc = [PFGeoPoint geoPointWithLocation:self.pointToSet];
    
    PFQuery *getQuery = [PFQuery queryWithClassName:kPostClassName];
    
    // builds query
    [getQuery whereKey:kCurLocKey nearGeoPoint:self.curLoc withinMiles:[self.distance intValue]];
    if (![self.groupSport isEqualToString:kUpAnyString]){
        [getQuery whereKey:kSportKey equalTo:self.groupSport];
    }
    if (![self.groupIntensity isEqualToString:kLowAnyKey]){
        [getQuery whereKey:kIntensityKey equalTo:self.groupIntensity];
    }
    [getQuery orderByDescending:kCurLocKey];
    getQuery.limit = 20;
    // TODO: infinite scroll
    [getQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self performSegueWithIdentifier:kGoToFeedSegue sender:nil];
        } else {
            NSLog(kStrInput, error.localizedDescription);
            //TODO: add user popup
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGoToFeedSegue]){
        UINavigationController *navigationVC = [segue destinationViewController];
        PMResultsViewController *tableVC = navigationVC.topViewController;
        tableVC.arrayOfPosts = self.arrayOfPosts;
        tableVC.distance = [self.distance intValue];
        tableVC.pointToSet = self.pointToSet;
        NSLog(kStrInput, self.distance);
    }
    
    if ([segue.identifier isEqualToString:kSportViewSegue]) {
        PMPickerViewController *childViewController = (PMPickerViewController *) [segue destinationViewController];
        childViewController.isSport = YES;
        childViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:kIntensityViewSegue]) {
        PMPickerViewController *childViewController = (PMPickerViewController *) [segue destinationViewController];
        childViewController.isSport = NO;
        childViewController.delegate = self;
    }
}


@end
