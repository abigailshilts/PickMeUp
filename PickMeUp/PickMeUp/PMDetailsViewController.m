//
//  DetailsView.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//

#import "PMDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PMDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sport;
@property (weak, nonatomic) IBOutlet UILabel *intensity;
@property (weak, nonatomic) IBOutlet UILabel *groupWhen;
@property (weak, nonatomic) IBOutlet UILabel *groupWhere;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PMDetailsViewController

static const NSString *const kShowDMSegue = @"showDM";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sport.text = self.post.sport;
    self.intensity.text = self.post.intensity;
    self.groupWhen.text = self.post.groupWhen;
    self.groupWhere.text = self.post.groupWhere;
    self.bio.text = self.post.bio;
    
    NSString *link = self.post.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.imgView setImageWithURL:url];
    
}
- (IBAction)didTapDM:(id)sender {
    [self performSegueWithIdentifier:kShowDMSegue sender:nil];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
