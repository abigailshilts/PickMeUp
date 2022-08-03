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
#import "PMGroupMessageViewController.h"
#import "PMReuseFunctions.h"
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
static const NSString *const kGoToGroupDM = @"goToGroupDM";

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

- (IBAction)didDoubleTap:(id)sender {
    if ([PFUser.currentUser[@"savedPosts"] containsObject:self.post]) {
        [PFUser.currentUser[@"savedPosts"] removeObject:self.post];
        [PFUser.currentUser saveInBackground];
        [PMReuseFunctions presentPopUp:kRemovedFromSaved message:kEmpt viewController:self];
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
        [PMReuseFunctions presentPopUp:kAddedToSaved message:kEmpt viewController:self];
    }
}

- (IBAction)didTapDM:(id)sender {
    if ([self.post.isEvent isEqualToString:kIsEventString]) {
        [self performSegueWithIdentifier:kGoToGroupDM sender:nil];
    } else {
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
                [PMReuseFunctions presentPopUp:kErrConvoQueryString message:kErrConvoQuerryMessage viewController:self];
            }
        }];

    }
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowDMSegue]) {
        UINavigationController *navigationVC = [segue destinationViewController];
        PMConversationViewController *convoVC = navigationVC.topViewController;
        convoVC.receiver = self.post.author;
        convoVC.convo = self.convo;
    }
    if ([segue.identifier isEqualToString:kGoToGroupDM]) {
        UINavigationController *navigationVC = [segue destinationViewController];
        PMGroupMessageViewController *GMVC = navigationVC.topViewController;
        GMVC.event = self.post;
    }
}


@end
