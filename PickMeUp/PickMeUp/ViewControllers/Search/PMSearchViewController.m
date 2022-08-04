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
#import "PMReuseFunctions.h"
#import "PMSearchViewController.h"
#import "Post.h"
#import "SceneDelegate.h"
#import "StringsList.h"

@interface PMSearchViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *distanceChoice;
@property (weak, nonatomic) IBOutlet UIView *sportContainer;
@property (strong, nonatomic) IBOutlet UIImageView *animationImg;
@property (strong, nonatomic) NSString *groupIntensity;
@property (strong, nonatomic) NSString *groupSport;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSMutableArray<Post *> *arrayOfPosts;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *pointToSet;
@property (strong, nonatomic) CLLocation *pointReceived;
@property (strong, nonatomic) PFGeoPoint *curLoc;

@end

@implementation PMSearchViewController

static const NSString *const kGoToFeedSegue = @"goToFeed";
static const NSString *const kSportViewSegue = @"sportView";
static const NSString *const kIntensityViewSegue = @"intensityView";
static const NSString *const kErrLogOutString = @"Error Loging Out";
static const NSString *const kErrLogOutMessage = @"Please try again";
static const NSString *const kErrQueryPostsString = @"Error Loading Posts";
static const NSString *const kErrQueryPostsMessage =
    @"Please check your internet and make sure all choices have been filled and try again";
static const NSString *const kErrQueryEventsString = @"Error Loading Events";
static const NSString *const kErrQueryEventsMessage =
    @"Please check your internet and try again";
static const NSString *const kXPosString = @"position.x";
static const NSString *const kBasicString = @"basic";
static const int kQuerySize = 20;
static const int kSecondsInDay = -86400;
static const int kEventRadious = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.distanceChoice.delegate = self;
    self.animationImg.hidden = YES;
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
            [PMReuseFunctions presentPopUp:kErrLogOutString message:kErrLogOutMessage viewController:self];
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

-(NSArray<Post *> *)refreshData {
    return self.arrayOfPosts;
}

- (IBAction)didTapGo:(id)sender {
    [self.locationManager stopUpdatingLocation];
    self.distance = self.distanceChoice.text;
    self.animationImg.image = [UIImage imageNamed:self.groupSport];
    self.animationImg.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = kXPosString;
    animation.fromValue = @77;
    animation.toValue = @455;
    animation.duration = 1;
    [self.animationImg.layer addAnimation:animation forKey:kBasicString];
    [self _runQuery];
}

- (void)_runQuery {
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
    [getQuery whereKey:kIsEventKey equalTo:kIsntEventString];
    [getQuery orderByDescending:kCurLocKey];
    getQuery.limit = kQuerySize;
    [getQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self _runEventQuery];
        } else {
            [PMReuseFunctions presentPopUp:kErrQueryPostsString message:kErrQueryPostsMessage viewController:self];
        }
    }];
}

-(void)_runEventQuery {
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:kSecondsInDay];
    PFQuery *getQuery = [PFQuery queryWithClassName:kPostClassName];
    [getQuery whereKey:kCurLocKey nearGeoPoint:self.curLoc withinMiles:kEventRadious];
    [getQuery whereKey:kCreatedAtKey greaterThanOrEqualTo:yesterday];
    [getQuery whereKey:kIsEventKey greaterThanOrEqualTo:kIsEventString];
    [getQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        if (events != nil) {
            NSMutableArray *toSet = [[NSMutableArray alloc]init];
            toSet = [NSMutableArray arrayWithArray:events];
            [toSet addObjectsFromArray:self.arrayOfPosts];
            self.arrayOfPosts = toSet;
            [self performSegueWithIdentifier:kGoToFeedSegue sender:nil];
        } else {
            [PMReuseFunctions presentPopUp:kErrQueryEventsString message:kErrQueryEventsMessage viewController:self];
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
        tableVC.toSet = self;
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
