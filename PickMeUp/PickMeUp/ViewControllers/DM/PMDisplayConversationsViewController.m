//
//  DisplayConversationsViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/15/22.
//
#import "PMCachingFunctions.h"
#import "PMConversationViewController.h"
#import "PMDataManager.h"
#import "PMDisplayConversationsCell.h"
#import "PMDisplayConversationsViewController.h"
#import "PMTree.h"
#import "StringsList.h"

@interface PMDisplayConversationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) PMTree *convoTree;
@property (strong, nonatomic) PMDataManager *manager;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFUser *receiver;
@property (strong, nonatomic) NSArray<PMConversation *> *arrayToDisplay;
@end

@implementation PMDisplayConversationsViewController

static const NSString *const kConvoCell = @"convoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.convoTree = [PMTree new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchField.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.currentUser = [PFUser currentUser];
    [self.searchField addTarget:self
                  action:@selector(_textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    
    self.manager = [PMDataManager dataManager];
    [self.manager fillConversations:^(NSArray<PMConversation *> *convos){
        for (PMConversation *conversation in convos) {
            [self.convoTree addConversation:conversation];
        }
        self.arrayToDisplay = [self.convoTree retrieveSubTree:kEmpt];
        [self.tableView reloadData];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
   [textField resignFirstResponder];
   return true;
}

-(void)_textFieldDidChange {
    self.arrayToDisplay = [self.convoTree retrieveSubTree:self.searchField.text];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMDisplayConversationsCell *cell = [tableView dequeueReusableCellWithIdentifier:kConvoCell forIndexPath:indexPath];
    PMConversation *conversation = self.arrayToDisplay[indexPath.row];
    if ([conversation.sender.username isEqual:self.currentUser.username]) {
        self.receiver = conversation.receiver;
    } else {
        self.receiver = conversation.sender;
    }
    [self.receiver fetchIfNeeded];
    cell.receiver.text = self.receiver.username;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayToDisplay.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *senderIndex = [self.tableView indexPathForCell: sender];
    UINavigationController *navigationVC = [segue destinationViewController];
    PMConversationViewController *convoVC = navigationVC.topViewController;
    PMConversation *convo = self.arrayToDisplay[senderIndex.row];
    convoVC.convo = convo;
    if ([PFUser.currentUser.username isEqualToString:convo.receiver.username]) {
        convoVC.receiver = convo.sender;
    } else {
        convoVC.receiver = convo.receiver;
    }
}


@end
