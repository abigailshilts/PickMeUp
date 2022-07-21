//
//  ResultsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import <CoreLocation/CoreLocation.h>
#import "PMDetailsViewController.h"
#import "PMEmbedTableViewController.h"
#import "PMMapViewController.h"
#import "PMPostCell.h"
#import "PMResultsViewController.h"
#import "StringsList.h"

@interface PMResultsViewController ()
@end

@implementation PMResultsViewController

static const NSString *const kGoToMapSegue = @"goToMap";
static const NSString *const kGetResultsSegue = @"getResults";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapMap:(id)sender {
    [self performSegueWithIdentifier:kGoToMapSegue sender:nil];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGetResultsSegue]) {
        PMEmbedTableViewController *childViewController = (PMEmbedTableViewController *) [segue destinationViewController];
        childViewController.arrayOfPosts = self.arrayOfPosts;
    }
    
    if ([segue.identifier isEqualToString:kGoToMapSegue]) {
        UINavigationController *navigationVC = [segue destinationViewController];
        PMMapViewController *mapVC = navigationVC.topViewController;
        mapVC.distance = self.distance;
        mapVC.pointToSet = self.pointToSet;
        mapVC.arrayOfPosts = self.arrayOfPosts;
    }
}

@end
