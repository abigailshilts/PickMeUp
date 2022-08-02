//
//  DetailsView.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//
#import "Parse/Parse.h"
#import "PMConversationViewController.h"
#import "PMConversation.h"
#import "PMDetailsViewController.h"
#import "StringsList.h"
#import "UIImageView+AFNetworking.h"

@interface PMDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sport;
@property (weak, nonatomic) IBOutlet UILabel *intensity;
@property (weak, nonatomic) IBOutlet UILabel *groupWhen;
@property (weak, nonatomic) IBOutlet UILabel *groupWhere;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) PMConversation *convo;

@end

@implementation PMDetailsViewController

static const NSString *const kShowDMSegue = @"showDM";
static const NSString *const kRemovedFromSaved = @"Removed post from saved posts";
static const NSString *const kAddedToSaved = @"Added post to saved posts";

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

-(void)_createPopUp:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkString style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{}];
}

- (IBAction)didDoubleTap:(id)sender {
    if ([PFUser.currentUser[@"savedPosts"] containsObject:self.post]) {
        [PFUser.currentUser[@"savedPosts"] removeObject:self.post];
        [PFUser.currentUser saveInBackground];
        [self _createPopUp:kRemovedFromSaved message:kEmpt];
    } else {
        if (PFUser.currentUser[@"savedPosts"] == nil) {
            PFUser.currentUser[@"savedPosts"] = [NSMutableArray new];
            [PFUser.currentUser[@"savedPosts"] addObject:self.post];
        } else {
            NSMutableArray<Post *> *toAdd = [NSMutableArray new];
            [toAdd addObjectsFromArray:PFUser.currentUser[@"savedPosts"]];
            [toAdd addObject:self.post];
            PFUser.currentUser[@"savedPosts"] = toAdd;
        }
        [PFUser.currentUser saveInBackground];
        [self _createPopUp:kAddedToSaved message:kEmpt];
    }
}

- (IBAction)didTapDM:(id)sender {
    PFQuery *getQuery = [PFQuery queryWithClassName:kConversationClassName];
    PFUser *currentUser = [PFUser currentUser];
    [self.post.author fetchIfNeeded];
    PFUser *author = self.post.author;
    [getQuery whereKey:kSenderKey equalTo:currentUser];
    [getQuery whereKey:kReceiverKey equalTo:author];
    [getQuery findObjectsInBackgroundWithBlock:^(NSArray *convos, NSError *error) {
        if (convos != nil) {
            if (convos.count > 0) {
                self.convo = convos[0];
            }
            else {
                self.convo = nil;
            }
            [self performSegueWithIdentifier:kShowDMSegue sender:nil];
        } else {
            [self _createPopUp:kErrConvoQueryString message:kErrConvoQuerryMessage];
        }
    }];

    
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationVC = [segue destinationViewController];
    PMConversationViewController *convoVC = navigationVC.topViewController;
    convoVC.receiver = self.post.author;
    convoVC.convo = self.convo;
}


@end
