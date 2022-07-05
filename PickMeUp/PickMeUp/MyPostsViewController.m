//
//  MyPostsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "MyPostsViewController.h"
#import "StringsList.h";

@interface MyPostsViewController ()

@end

@implementation MyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapMakePost:(id)sender {
    [self performSegueWithIdentifier:goToMakePost sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
