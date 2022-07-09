//
//  EmbedTableViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/8/22.
//

#import "EmbedTableViewController.h"
#import "PostCell.h"
#import "DetailsViewController.h"

@interface EmbedTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EmbedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.row];
    
    cell.post = post;
    [cell setPost];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"goToDetails"]){
        NSIndexPath *senderIndex = [self.tableView indexPathForCell: sender];
        UINavigationController *navigationVC = [segue destinationViewController];
        DetailsViewController *displayVC = navigationVC.topViewController;
        Post *post = self.arrayOfPosts[senderIndex.row];
        displayVC.post = post;
        
    }
}


@end
