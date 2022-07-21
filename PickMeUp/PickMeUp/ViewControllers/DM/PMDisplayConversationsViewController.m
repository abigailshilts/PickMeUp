//
//  DisplayConversationsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/15/22.
//
#import "PMConversationViewController.h"
#import "PMDisplayConversationsCell.h"
#import "PMDisplayConversationsViewController.h"
#import "StringsList.h"

@interface PMDisplayConversationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<PMConversation *> *arrayOfConversations;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFUser *receiver;
@end

@implementation PMDisplayConversationsViewController

static const NSString *const kConvoCell = @"convoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 80; // needs to be changed later to make row height responsive to content
    self.currentUser = [PFUser currentUser];
    //[self.tableView reloadData];
    [self _runGetQuery];
}

-(void)_runGetQuery {
    // Populates conversation array
    // builds query to search for currentUser in either user1 or user2
    PFQuery *user1 = [PFQuery queryWithClassName:kConversationClassName];
    [user1 whereKey:kSenderKey equalTo:self.currentUser];
    PFQuery *user2 = [PFQuery queryWithClassName:kConversationClassName];
    [user2 whereKey:kReceiverKey equalTo:self.currentUser];
    PFQuery *toQuery = [PFQuery orQueryWithSubqueries:@[user1, user2]];
    toQuery.limit = 30;
    toQuery.skip = self.arrayOfConversations.count;
    [toQuery findObjectsInBackgroundWithBlock:^(NSArray *convos, NSError *error) {
        if (convos != nil) {
            if (self.arrayOfConversations == nil) {
                self.arrayOfConversations = convos;
            } else {
                [self.arrayOfConversations arrayByAddingObjectsFromArray:convos];
            }
            [self.tableView reloadData];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:kErrConvoQueryString message:kErrConvoQuerryMessage preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkString style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{}];
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMDisplayConversationsCell *cell = [tableView dequeueReusableCellWithIdentifier:kConvoCell forIndexPath:indexPath];
    PMConversation *conversation = self.arrayOfConversations[indexPath.row];
    if ([conversation.sender.objectId isEqual:self.currentUser.objectId]) {
        self.receiver = conversation.receiver;
    } else {
        self.receiver = conversation.sender;
    }
    [self.receiver fetchIfNeeded];
    cell.receiver.text = self.receiver.username;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfConversations.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == (self.arrayOfConversations.count - 2)){
        [self _runGetQuery];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *senderIndex = [self.tableView indexPathForCell: sender];
    UINavigationController *navigationVC = [segue destinationViewController];
    PMConversationViewController *convoVC = navigationVC.topViewController;
    PMConversation *convo = self.arrayOfConversations[senderIndex.row];
    convoVC.convo = convo;
    convoVC.receiver = self.receiver;
}


@end
