//
//  EmbedTableViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import "PMDetailsViewController.h"
#import "PMEmbedTableViewController.h"
#import "PMPostCell.h"
#import "StringsList.h"


@interface PMEmbedTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PMEmbedTableViewController

static const NSString *const kGoToDetailsSegue = @"goToDetails";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPostCell *cell = [tableView dequeueReusableCellWithIdentifier:postCell forIndexPath:indexPath];
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
