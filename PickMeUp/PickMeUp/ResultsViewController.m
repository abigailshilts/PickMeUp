//
//  ResultsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "ResultsViewController.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "EmbedTableViewController.h"

@interface ResultsViewController ()
@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"getResults"]) {
        EmbedTableViewController *childViewController = (EmbedTableViewController *) [segue destinationViewController];
        childViewController.arrayOfPosts = self.arrayOfPosts;
    }
}

@end
