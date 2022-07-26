//
//  SavedPostsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/25/22.
//

#import "SavedPostsViewController.h"
#import "PMEmbedTableViewController.h"

@interface SavedPostsViewController () <PMEmbedTableViewControllerDelegate>

@end

@implementation SavedPostsViewController

static const NSString *const kSavedPostsKey = @"savedPosts";

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSArray<Post *> *)refreshData {
    PFUser *currentUser = PFUser.currentUser;
    return currentUser[kSavedPostsKey];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PMEmbedTableViewController *childViewController = (PMEmbedTableViewController *) [segue destinationViewController];
    PFUser *currentUser = PFUser.currentUser;
    [currentUser fetchIfNeeded];
    childViewController.arrayOfPosts = currentUser[kSavedPostsKey];
    childViewController.delegate = self;
}


@end
