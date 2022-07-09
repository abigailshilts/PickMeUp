//
//  SearchViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "SearchViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "StringsList.h"
#import "Post.h"
#import "ResultsViewController.h"
#import "PickerViewController.h"


@interface SearchViewController () <PickerViewControllerDelegate>
//@property (weak, nonatomic) IBOutlet UIPickerView *intensityPicker;
//@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UITextField *distanceChoice;
@property (strong, nonatomic) NSString *groupIntensity;
@property (strong, nonatomic) NSString *groupSport;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (weak, nonatomic) IBOutlet UIView *sportContainer;
//@property (strong, nonatomic) NSArray *intensity;
//@property (strong, nonatomic) NSArray *sport;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *mySceneDelegate = (SceneDelegate * )
        UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:mainStr bundle:nil];
    UIViewController *loginViewController =
        [storyboard instantiateViewControllerWithIdentifier:logViewController];
    mySceneDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
}

-(void)recieveSport:(NSString *)sport {
    self.groupSport = sport;
}

-(void)recieveIntensity:(NSString *)intensity {
    self.groupIntensity = intensity;
}

- (IBAction)didTapGo:(id)sender {
    self.distance = self.distanceChoice.text;
    NSLog(@"%@", self.groupIntensity);
    [self query];
}

- (void)query {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    if (![self.groupSport isEqualToString:@"Any"]){
        [query whereKey:@"sport" equalTo:self.groupSport];
    }
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            NSLog(@"success");
            [self performSegueWithIdentifier:@"goToFeed" sender:nil];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"goToFeed"]){
        UINavigationController *navigationVC = [segue destinationViewController];
        ResultsViewController *tableVC = navigationVC.topViewController;
        tableVC.arrayOfPosts = self.arrayOfPosts;
        NSLog(@"%@", self.distance);
    }
    
    if ([segue.identifier isEqualToString:@"sportView"]) {
        PickerViewController *childViewController = (PickerViewController *) [segue destinationViewController];
        childViewController.isSport = 1;
        childViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"intensityView"]) {
        PickerViewController *childViewController = (PickerViewController *) [segue destinationViewController];
        childViewController.isSport = 0;
        childViewController.delegate = self;
    }
}


@end
