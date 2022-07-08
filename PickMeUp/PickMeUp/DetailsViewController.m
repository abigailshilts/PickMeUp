//
//  DetailsView.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sport;
@property (weak, nonatomic) IBOutlet UILabel *intensity;
@property (weak, nonatomic) IBOutlet UILabel *groupWhen;
@property (weak, nonatomic) IBOutlet UILabel *groupWhere;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //self.scrollView.scrollEnabled = YES;
    //self.scrollView.showsVerticalScrollIndicator = YES;
    //self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 2);
    //[self.view addSubview:scrollView];

    self.sport.text = self.post.sport;
    self.intensity.text = self.post.intensity;
    self.groupWhen.text = self.post.groupWhen;
    self.groupWhere.text = self.post.groupWhere;
    self.bio.text = self.post.bio;
    
    NSString *link = self.post.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.imgView setImageWithURL:url];
    
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
