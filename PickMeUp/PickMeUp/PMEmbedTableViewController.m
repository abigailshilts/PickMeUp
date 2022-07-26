//
//  EmbedTableViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import "CBStoreHouseRefreshControl-umbrella.h"
#import "PMDetailsViewController.h"
#import "PMEmbedTableViewController.h"
#import "PMPostCell.h"
#import "StringsList.h"


@interface PMEmbedTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@end

@implementation PMEmbedTableViewController

static const NSString *const kGoToDetailsSegue = @"goToDetails";
static const NSString *const kPostCellIdentifier = @"postCell";
static const NSString *const kStoreHouseFile = @"storeHouse";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:kStoreHouseFile color:[UIColor darkGrayColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.arrayOfPosts = [self.delegate refreshData];
    [self.tableView reloadData];
    [self.storeHouseRefreshControl finishingLoading];
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

//- (void)refreshTriggered {
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPostCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostCellIdentifier forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.row];
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
        Post *post = self.arrayOfPosts[senderIndex.row];
        displayVC.post = post;
        
    }
}


@end
