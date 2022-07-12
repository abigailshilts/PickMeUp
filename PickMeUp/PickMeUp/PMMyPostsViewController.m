//
//  MyPostsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//
#import "PMEmbedTableViewController.h"
#import "PMMyPostsViewController.h"
#import "Parse/Parse.h"
#import "PMPostCell.h"
#import "Post.h"
#import "StringsList.h";

@interface PMMyPostsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl*refreshControl;
@end

@implementation PMMyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)query {
    PFQuery *query = [PFQuery queryWithClassName:classPost];
    [query whereKey:keyAuthor equalTo:PFUser.currentUser];
    self.arrayOfPosts = [query findObjects];
}

- (IBAction)didTapMakePost:(id)sender {
    [self performSegueWithIdentifier:goToMakePost sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self query];
    if ([segue.identifier isEqualToString:getMyPosts]) {
        PMEmbedTableViewController *childViewController = (PMEmbedTableViewController *) [segue destinationViewController];
        childViewController.arrayOfPosts = self.arrayOfPosts;
    }
}


@end
