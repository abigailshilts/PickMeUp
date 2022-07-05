//
//  ResultsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "ResultsViewController.h"

@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) NSArray<Post *> *arrayOfPosts;
@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self query];
    // Do any additional setup after loading the view.
}

-(void)query {
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// //   return self.arrayOfPosts.count;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
