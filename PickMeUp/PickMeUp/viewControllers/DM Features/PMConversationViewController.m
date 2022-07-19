//
//  ConversationViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.receiverName.text = self.receiver.username;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.messageToSend.delegate = self;
    
    [self _createLiveQueryObj];
    self.msgQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
    [self.msgQuery whereKey:kConvoIdKey equalTo:self.convo.objectId];
    self.subscription = [self.liveQueryClient subscribeToQuery:self.msgQuery];
    __weak typeof(self) weakSelf = self;
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        __strong typeof(self) strongSelf = weakSelf;
        [self.arrayOfDMs addObject:(PMDirectMessage *)object];
        dispatch_async(dispatch_get_main_queue(), ^{[self.tableView reloadData];});
    }];
    [self _runGetQuery];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }

    [txtView resignFirstResponder];
    return NO;
}

-(void)_createLiveQueryObj {
    NSString *path = [[NSBundle mainBundle] pathForResource:kKeysString ofType:kPlistTitle];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey:kAppIDString];
    NSString *secret = [dict objectForKey:kClientKey];

    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:kLiveQueryURL applicationId:key clientKey:secret];
}

-(void)_runGetQuery {
    // Populates DM array
    if (self.convo == nil) {
        self.noDMs = YES;
    } else {
        self.noDMs = NO;
        PFQuery *getQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
        [getQuery whereKey:kConvoIdKey equalTo:self.convo.objectId];
        [getQuery findObjectsInBackgroundWithBlock:^(NSArray *DMs, NSError *error) {
            if (DMs != nil) {
                self.arrayOfDMs = DMs;
                [self.tableView reloadData];
            } else {
                NSLog(kStrInput, error.localizedDescription);
            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMDMCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell prepareForReuse];
    PMDirectMessage *currDM = self.arrayOfDMs[indexPath.row];
    PFUser *sender = [currDM.sender fetchIfNeeded];
    cell.content.text = currDM.content;
    if ([sender.username isEqual:PFUser.currentUser.username]){
        cell.content.textAlignment=NSTextAlignmentRight;
    } else {
        cell.content.backgroundColor = [UIColor systemMintColor];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDMs.count;
}

-(void)_saveDM {
    // posts DM to database and refreshes the table
    PMDirectMessage *newDM = [PMDirectMessage new];
    newDM.content = self.messageToSend.text;
    newDM.convoId = self.convo.objectId;
    newDM.sender = PFUser.currentUser;
    [newDM postDM:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil){
            NSLog(kPostingErrString);
        } else {
            [self _runGetQuery];
        }
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
                NSLog(kPostingErrString);
            } else {
                self.noDMs = NO;
                self.convo = newConvo;
                [self _saveDM];
            }
        }];
    } else {
        [self _saveDM];
    }

 
}

@end
