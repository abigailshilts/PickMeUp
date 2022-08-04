//
//  ConversationViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "Parse/Parse.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "PMCachingFunctions.h"
#import "PMConversationViewController.h"
#import "PMDataManager.h"
#import "PMDirectMessage.h"
#import "PMDMCell.h"
#import "PMReuseFunctions.h"
#import "StringsList.h"

@interface PMConversationViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *receiverName;
@property (strong, nonatomic) IBOutlet UITextView *messageToSend;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray<PMDirectMessage *> *arrayOfDMs;
@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFQuery *msgQuery;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;
@property (strong, nonatomic) PMDataManager *manager;
@property BOOL noDMs;
@property NSInteger pageCount;
@property int totalObjects;
@property int pageObjectNum;
@end

@implementation PMConversationViewController

static const NSString *const kConvoIdKey = @"convoId";
static const NSString *const kCellIdentifier = @"DMCell";
static const NSString *const kPostingErrString = @"error on Post request";
static const NSString *const kErrCreateConvoString = @"Creating Conversation Error";
static const NSString *const kErrCreateConvoMessage =
    @"There appears to be an error with saving this conversation, check your internet and try again";
static const NSString *const kErrQueryForDMString = @"Error Retrieving Messages";
static const NSString *const kErrQueryForDMMessage =
    @"There appears to be an error retreiving this conversation, check your internet and try again";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.receiverName.text = self.receiver.username;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.messageToSend.delegate = self;
    
    if (self.convo != nil) {
        self.liveQueryClient = [PMReuseFunctions createLiveQueryObj];
        [self _finishCreatingLiveQuery];
        PFQuery *countQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
        [countQuery whereKey:kConvoIdKey equalTo:self.convo.objectId];
        self.totalObjects = [countQuery countObjects];
    } else {
        self.totalObjects = 0;
    }
    
    self.pageCount = 1;
    self.pageObjectNum = 30;
    
    self.manager = [PMDataManager dataManager];
    if (self.convo != nil) {
        self.noDMs = NO;
        [self.manager fillDMs:self.convo.objectId withBlock:^(NSArray<PMDirectMessage *> *DMs){
            self.arrayOfDMs = DMs;
            [self.tableView reloadData];
        }];
    } else {
        self.noDMs = YES;
    }
}

-(void)_finishCreatingLiveQuery {
    self.msgQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
    [self.msgQuery whereKey:kConvoIdKey equalTo:self.convo.objectId];
    self.subscription = [self.liveQueryClient subscribeToQuery:self.msgQuery];
    __weak typeof(self) weakSelf = self;
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.arrayOfDMs insertObject:(PMDirectMessage *)object atIndex:0];
            strongSelf.totalObjects++;
            [strongSelf.tableView reloadData];
        });
    }];
}

- (IBAction)didTapBack:(id)sender {
    if (self.convo != nil) {
        [self.manager saveDMs:self.arrayOfDMs conversation:self.convo.objectId];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }

    [txtView resignFirstResponder];
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMDMCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    PMDirectMessage *currDM = self.arrayOfDMs[indexPath.row];
    PFUser *sender = [currDM.sender fetchIfNeeded];
    cell.content.text = currDM.content;
    [cell configureWithUser:sender];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDMs.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    int totalPages = (self.totalObjects + self.pageObjectNum)/self.pageObjectNum;
    if (self.pageCount != totalPages){
        if (indexPath.row == self.arrayOfDMs.count-2){
            [self.manager loadMoreDMs:self.convo.objectId pageCount:self.pageCount withBlock:^(NSArray<PMDirectMessage *> *DMs){
                [self.arrayOfDMs addObjectsFromArray:DMs];
                [self.tableView reloadData];
            }];
            self.pageCount++;
        }
    }
}

- (IBAction)didTapSend:(id)sender {
    // posts convo if needed and makes call to function to save DM
    self.sendBtn.enabled = NO;
    if (self.noDMs == YES){
        PMConversation *newConvo = [PMConversation new];
        newConvo.sender = PFUser.currentUser;
        newConvo.receiver = self.receiver;
        [newConvo postConvo:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil){
                [PMReuseFunctions presentPopUp:kErrCreateConvoString message:kErrCreateConvoMessage viewController:self];
            } else {
                self.noDMs = NO;
                self.convo = newConvo;
                [PMReuseFunctions saveDM:self.messageToSend.text searchById:self.convo.objectId];
                self.messageToSend.text = kEmpt;
                self.sendBtn.enabled = YES;
                self.arrayOfDMs = [NSMutableArray new];
                self.liveQueryClient = [PMReuseFunctions createLiveQueryObj];
                [self _finishCreatingLiveQuery];
            }
        }];
    } else {
        [PMReuseFunctions saveDM:self.messageToSend.text searchById:self.convo.objectId];
        self.messageToSend.text = kEmpt;
        self.sendBtn.enabled = YES;
    }
}

@end
