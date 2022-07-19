//
//  ConversationViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "Parse/Parse.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "PMConversationViewController.h"
#import "PMDirectMessage.h"
#import "PMDMCell.h"
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
@property BOOL noDMs;
@end

@implementation PMConversationViewController

static const NSString *const kConvoIdKey = @"convoId";
static const NSString *const kCellIdentifier = @"DMCell";
static const NSString *const kPostingErrString = @"error on Post request";
static const NSString *const kLiveQueryURL = @"wss://pickmeup.b4a.io";
static const NSString *const kErrCreateConvoString = @"Creating Conversation Error";
static const NSString *const kErrCreateConvoMessage =
    @"There appears to be an error with saving this conversation, check your internet and try again";
static const NSString *const kErrCreateDMString = @"Creating Message Error";
static const NSString *const kErrCreateDMMessage =
    @"There appears to be an error with saving this message, check your internet and try again";
static const NSString *const kErrQueryForDMString = @"Error Retrieving Messages";
static const NSString *const kErrQueryForDMMessage =
    @"There appears to be an error retreiving this conversation, check your internet and try again";
static const NSString *const kCreatedAtKey = @"createdAt";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.receiverName.text = self.receiver.username;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.messageToSend.delegate = self;
    
    if (self.convo != nil) {
        [self _finishCreatingLiveQuery];
    }
    
    [self _runGetQuery];
    // creates bottom refresh control
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.triggerVerticalOffset = 100.;
    [refreshControl addTarget:self action:@selector(_runGetQuery) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = refreshControl;}

-(void)_createPopUp:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkString style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{}];
}

-(void)_finishCreatingLiveQuery {
    [self _createLiveQueryObj];
    self.msgQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
    [self.msgQuery whereKey:kConvoIdKey equalTo:self.convo.objectId];
    self.subscription = [self.liveQueryClient subscribeToQuery:self.msgQuery];
    __weak typeof(self) weakSelf = self;
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.arrayOfDMs addObject:(PMDirectMessage *)object];
            [strongSelf.tableView reloadData];
        });
    }];
}

-(void)_createLiveQueryObj {
    NSString *path = [[NSBundle mainBundle] pathForResource:kKeysString ofType:kPlistTitle];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [dict objectForKey:kAppIDString];
    NSString *secret = [dict objectForKey:kClientKey];

    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:kLiveQueryURL applicationId:key clientKey:secret];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }

    [txtView resignFirstResponder];
    return NO;
}

-(void)_runGetQuery {
    // Populates DM array
    if (self.convo == nil) {
        self.noDMs = YES;
    } else {
        self.noDMs = NO;
        PFQuery *getQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
        [getQuery whereKey:kConvoIdKey equalTo:self.convo.objectId];
        getQuery.limit = 30;
        [getQuery orderByDescending:kCreatedAtKey];
        if (self.arrayOfDMs != nil) {
            getQuery.skip = self.arrayOfDMs.count;
        }
        [getQuery findObjectsInBackgroundWithBlock:^(NSArray *DMs, NSError *error) {
            if (DMs != nil) {
                if (self.arrayOfDMs == nil){
                    self.arrayOfDMs = DMs;
                } else {
                    self.arrayOfDMs = [self.arrayOfDMs arrayByAddingObjectsFromArray:DMs];
                }
                [self.tableView reloadData];
            } else {
                [self _createPopUp:kErrQueryForDMString message:kErrQueryForDMMessage];
            }
            [self.tableView.bottomRefreshControl endRefreshing];
        }];
    }
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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
//    forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == (self.arrayOfDMs.count - 2)){
//        [self _runGetQuery];
//    }
//}

-(void)_saveDM {
    // posts DM to database and refreshes the table
    PMDirectMessage *newDM = [PMDirectMessage new];
    newDM.content = self.messageToSend.text;
    newDM.convoId = self.convo.objectId;
    newDM.sender = PFUser.currentUser;
    [newDM postDM:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil){
            [self _createPopUp:kErrCreateDMString message:kErrCreateDMMessage];
        }
//        else {
//            [self _runGetQuery];
//        }
        self.messageToSend.text = kEmpt;
        self.sendBtn.enabled = YES;
    }];
}

- (IBAction)didTapSend:(id)sender {
    // posts convo if needed and makes call to function to save DM
    self.sendBtn.enabled = NO;
    if (self.noDMs == YES){
        PMConversation *newConvo = [PMConversation new];
        [newConvo postConvo:PFUser.currentUser
                  otherUser:self.receiver withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil){
                [self _createPopUp:kErrCreateConvoString message:kErrCreateConvoMessage];
            } else {
                self.noDMs = NO;
                self.convo = newConvo;
                [self _saveDM];
                [self _finishCreatingLiveQuery];
            }
        }];
    } else {
        [self _saveDM];
    }

 
}

@end
