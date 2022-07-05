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


@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
