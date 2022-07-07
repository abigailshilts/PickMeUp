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


@interface SearchViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *intensityPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UITextField *distanceChoice;
@property (strong, nonatomic) NSString *groupIntensity;
@property (strong, nonatomic) NSString *groupSport;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (strong, nonatomic) NSArray *intensity;
@property (strong, nonatomic) NSArray *sport;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.intensityPicker.delegate = self;
    self.intensityPicker.dataSource = self;
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    self.intensity = [NSArray arrayWithObjects: @"low", @"medium", @"high", @"any", nil];
    self.sport = [NSArray arrayWithObjects: @"Any", @"Soccer", @"Hockey", @"Football", @"Baseball/Softball", @"Frisbee", @"Spikeball", @"Volleyball", @"Other", nil];
    
    
    // Do any additional setup after loading the view.
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:self.intensityPicker]){
        return 4;
    } else {
        return 9;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
//    NSArray *intensity = [NSArray arrayWithObjects: @"low", @"medium", @"high", @"any", nil];
//    NSArray *sport = [NSArray arrayWithObjects: @"Any", @"Soccer", @"Hockey", @"Football", @"Baseball/Softball", @"Frisbee", @"Spikeball", @"Volleyball", @"Other", nil];
    if ([pickerView isEqual:self.intensityPicker]){
        title = self.intensity[row];
        //self.groupIntensity = title;
    } else {
        title = self.sport[row];
        //self.groupSport = title;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.intensityPicker]){
        self.groupIntensity = self.intensity[row];
    } else {
        self.groupSport = self.sport[row];
    }
}

- (IBAction)didTapGo:(id)sender {
    self.distance = self.distanceChoice.text;
    NSLog(@"%@", self.distance);
    NSLog(@"%@", self.groupSport);
    NSLog(@"%@", self.groupIntensity);
    [self query];
    //[self performSegueWithIdentifier:@"goToFeed" sender:nil];
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

//- (IBAction)didTapButton:(id)sender {
//    NSPopUpButton *btn = (NSPopUpButton*)sender;
//
//    int index = [btn indexOfSelectedItem];
//    student *std = [studentArray objectAtIndex:index];
//
//    NSLog(@"%@ => %@", [std name], [std date]);
//}


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
}


@end
