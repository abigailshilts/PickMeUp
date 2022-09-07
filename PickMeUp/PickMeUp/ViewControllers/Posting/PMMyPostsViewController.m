//
//  MyPostsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//
#import "Parse/Parse.h"
#import "PickMeUp-Swift.h"
#import "PMEmbedTableViewController.h"
#import "PMMyPostsViewController.h"
#import "PMPostCell.h"
#import "Post.h"
#import "StringsList.h"
@import FirebaseCore;
@import FirebaseFirestore;
@import FirebaseStorage;

@interface PMMyPostsViewController () <PMEmbedTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<PMPost *> *arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl*refreshControl;
@end

@implementation PMMyPostsViewController

static const NSString *const kGoToMakePostSegue = @"goToMakePost";
static const NSString *const kGetMyPostsSegue = @"getMyPosts";
static const NSString *const kGoToSavedSegue = @"goToSaved";
static const NSString *const kGoToMakeEvent = @"goToMakeEvent";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSaved:(id)sender {
    [self performSegueWithIdentifier:kGoToSavedSegue sender:nil];
}

- (IBAction)didTapMakeEvent:(id)sender {
    [self performSegueWithIdentifier:kGoToMakeEvent sender:nil];
}

-(void)runQuery:(void(^)(NSArray<PMPost *> *))completionBlock {
    [[[[FIRFirestore firestore] collectionWithPath:kPosts] queryWhereField:kAuthor isEqualTo:PFUser.currentUser.objectId]
        getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
        } else {
            NSMutableArray<PMPost *> *arr = [NSMutableArray new];
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                NSLog(@"%@ => %@", document.documentID, document.data);
                self.arrayOfPosts = [NSMutableArray new];
                PMPost *toAdd = [PMPost makePostWithDoc:document];
                PFQuery *query = [PFUser query];
                [query whereKey:@"objectId" equalTo:document.data[@"author"]];
                NSArray *users = [query findObjects];
                [toAdd addAuthWithUse:users[0]];
                [arr addObject:toAdd];
            }
            completionBlock(arr);
          }
    }];
}

- (IBAction)didTapMakePost:(id)sender {
    [self performSegueWithIdentifier:kGoToMakePostSegue sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGetMyPostsSegue]) {
        PMEmbedTableViewController *childViewController = (PMEmbedTableViewController *) [segue destinationViewController];
        childViewController.arrayOfPosts = self.arrayOfPosts;
        childViewController.delegate = self;
    }
}


@end
