//
//  DetailsView.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/7/22.
//
#import "Parse/Parse.h"
#import "PickMeUp-Swift.h"
#import "PMConversationViewController.h"
#import "PMConversation.h"
#import "PMDetailsViewController.h"
#import "PMGroupMessageViewController.h"
#import "PMReuseFunctions.h"
#import "StringsList.h"
#import "UIImageView+AFNetworking.h"
@import FirebaseCore;
@import FirebaseStorage;
@import FirebaseStorageUI;

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
static const NSString *const kSavedPostsKey = @"savedPosts";

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.post.isEvent isEqualToString:kIsEventString]) {
        self.sport.text = self.post.groupWhen;
        self.intensity.text = self.post.groupWhere;
        self.groupWhen.hidden = YES;
        self.groupWhere.hidden = YES;
    } else {
        self.sport.text = self.post.sport;
        self.intensity.text = self.post.intensity;
        self.groupWhen.text = self.post.groupWhen;
        self.groupWhere.text = self.post.groupWhere;
    }
    
    self.bio.text = self.post.bio;
    UIImage *placeholderImage;
    [self.imgView sd_setImageWithStorageReference:self.post.storageRef placeholderImage:placeholderImage];
    
}

- (IBAction)didDoubleTap:(id)sender {
    for (Post *curPost in PFUser.currentUser[kSavedPostsKey]) {
        if ([curPost.objectId isEqualToString:self.post.ident]) {
            [PFUser.currentUser[kSavedPostsKey] removeObject:curPost];
            [PFUser.currentUser saveInBackground];
            [PMReuseFunctions presentPopUp:kRemovedFromSaved message:kEmpt viewController:self];
            return;
        }
    }
    if (PFUser.currentUser[kSavedPostsKey] == nil) {
        PFUser.currentUser[kSavedPostsKey] = [NSMutableArray new];
        [PFUser.currentUser[kSavedPostsKey] addObject:self.post];
    } else {
        NSMutableArray<Post *> *toAdd = [NSMutableArray new];
        [toAdd addObjectsFromArray:PFUser.currentUser[kSavedPostsKey]];
        [toAdd addObject:self.post];
        PFUser.currentUser[kSavedPostsKey] = toAdd;
    }
    [PFUser.currentUser saveInBackground];
    [PMReuseFunctions presentPopUp:kAddedToSaved message:kEmpt viewController:self];

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
