//
//  MyPostsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//
#import "Parse/Parse.h"
#import "PMEmbedTableViewController.h"
#import "PMMyPostsViewController.h"
#import "PMPostCell.h"
#import "Post.h"
#import "StringsList.h";

@interface PMMyPostsViewController () <PMEmbedTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl*refreshControl;
@end

@implementation PMMyPostsViewController

static const NSString *const kGoToMakePostSegue = @"goToMakePost";
static const NSString *const kGetMyPostsSegue = @"getMyPosts";
static const NSString *const kGoToSavedSegue = @"goToSaved";
static const NSString *const kGoToMakeEvent = @"goToMakeEvent";
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSArray<Post *> *)refreshData {
    [self _runQuery];
    return self.arrayOfPosts;
}

- (IBAction)didTapSaved:(id)sender {
    [self performSegueWithIdentifier:kGoToSavedSegue sender:nil];
}

- (IBAction)didTapMakeEvent:(id)sender {
    [self performSegueWithIdentifier:kGoToMakeEvent sender:nil];
}

-(void)_runQuery {
    PFQuery *getQuery = [PFQuery queryWithClassName:kPostClassName];
    [getQuery whereKey:kAuthorKey equalTo:PFUser.currentUser];
    self.arrayOfPosts = [getQuery findObjects];
}

- (IBAction)didTapMakePost:(id)sender {
    [self performSegueWithIdentifier:kGoToMakePostSegue sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self _runQuery];
    if ([segue.identifier isEqualToString:kGetMyPostsSegue]) {
        PMEmbedTableViewController *childViewController = (PMEmbedTableViewController *) [segue destinationViewController];
        childViewController.arrayOfPosts = self.arrayOfPosts;
        childViewController.delegate = self;
    }
}


@end
