//
//  EmbedTableViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import "CBStoreHouseRefreshControl-umbrella.h"
#import "PickMeUp-Swift.h"
#import "PMDetailsViewController.h"
#import "PMEmbedTableViewController.h"
#import "PMSearchViewController.h"
#import "PMPostCell.h"
#import "StringsList.h"
@import FirebaseCore;
@import FirebaseFirestore;

@interface PMEmbedTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@end

@implementation PMEmbedTableViewController

static const NSString *const kGoToDetailsSegue = @"goToDetails";
static const NSString *const kPostCellIdentifier = @"postCell";
static const NSString *const kStoreHouseFile = @"storeHouse";
static const NSString *const kYesString = @"yes";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([self.isMy isEqualToString:kYesString]) {
        [self.delegate runQuery:^(NSArray<PMPost *> *posts){
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
        }];
    }
    else {
        [PMPost getPostsWithSelectedSport:self.sport selectedIntensity:self.intensity loc:self.loc dist:self.dist finished:^(NSArray *arr) {
            self.arrayOfPosts = arr;
            [self.tableView reloadData];
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.isMy isEqualToString:kYesString]) {
        [self.delegate runQuery:^(NSArray<PMPost *> *posts){
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
        }];
    }
    else {
        [PMPost getPostsWithSelectedSport:self.sport selectedIntensity:self.intensity loc:self.loc dist:self.dist finished:^(NSArray *arr) {
            self.arrayOfPosts = arr;
            [self.tableView reloadData];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPostCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostCellIdentifier forIndexPath:indexPath];
    PMPost *post = self.arrayOfPosts[indexPath.row];
    [cell setPost:post];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGoToDetailsSegue]){
        NSIndexPath *senderIndex = [self.tableView indexPathForCell: sender];
        UINavigationController *navigationVC = [segue destinationViewController];
        PMDetailsViewController *displayVC = navigationVC.topViewController;
        PMPost *post = self.arrayOfPosts[senderIndex.row];
        displayVC.post = post;
        
    }
}


@end
