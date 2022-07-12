//
//  ResultsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import <CoreLocation/CoreLocation.h>
#import "PMDetailsViewController.h"
#import "PMEmbedTableViewController.h"
#import "PMPostCell.h"
#import "ResultsViewController.h"
#import "StringsList.h"

@interface PMResultsViewController ()
@end

@implementation PMResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:getResults]) {
        PMEmbedTableViewController *childViewController = (PMEmbedTableViewController *) [segue destinationViewController];
        childViewController.arrayOfPosts = self.arrayOfPosts;
    }
}

@end
