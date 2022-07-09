//
//  MyPostsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "MyPostsViewController.h"
#import "StringsList.h";
#import "Parse/Parse.h"
#import "PostCell.h"
#import "Post.h"
#import "EmbedTableViewController.h"

@interface MyPostsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Post *> *arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl*refreshControl;
@end

@implementation MyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;


//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(query) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:self.refreshControl];
}

-(void)query {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    self.arrayOfPosts = [query findObjects];
}

- (IBAction)didTapMakePost:(id)sender {
    [self performSegueWithIdentifier:goToMakePost sender:nil];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
//    Post *post = self.arrayOfPosts[indexPath.row];
//
//    cell.post = post;
//    [cell setMyPost];
//
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.arrayOfPosts.count;
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self query];
    if ([segue.identifier isEqualToString:@"getMyPosts"]) {
        EmbedTableViewController *childViewController = (EmbedTableViewController *) [segue destinationViewController];
        childViewController.arrayOfPosts = self.arrayOfPosts;
    }
}


@end
