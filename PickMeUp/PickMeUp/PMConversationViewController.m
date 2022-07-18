//
//  ConversationViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import "PMConversationViewController.h"
#import "PMDirectMessage.h"
#import "PMDMCell.h"
#import "StringsList.h"

@interface PMConversationViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *recieverName;
@property (strong, nonatomic) IBOutlet UITextView *messageToSend;
@property (strong, nonatomic) IBOutlet UIButton *mybtn;
@property (strong, nonatomic) NSMutableArray<PMDirectMessage *> *arrayOfDMs;
@property BOOL noDMs;
@end

@implementation PMConversationViewController

static const NSString *const kConvoIdKey = @"convoId";
static const NSString *const kCellIdentifier = @"DMCell";
static const NSString *const kPostingErrString = @"error on Post request";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recieverName.text = self.receiver.username;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.messageToSend.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self runGetQuery];
}

- (void)onTimer {
    [self runGetQuery];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }

    [txtView resignFirstResponder];
    return NO;
}

-(void)runGetQuery {
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
    cell.content.text = self.arrayOfDMs[indexPath.row].content;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDMs.count;
}

-(void)saveDM {
    // posts DM to database and refreshes the table
    self.mybtn.enabled = NO;
    PMDirectMessage *newDM = [PMDirectMessage new];
    newDM.content = self.messageToSend.text;
    newDM.convoId = self.convo.objectId;
    [newDM postDM:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil){
            NSLog(kPostingErrString);
        } else {
            [self runGetQuery];
            [self.tableView reloadData];

        }
        self.messageToSend.text = kEmpt;
    }];
}

- (IBAction)didTapSend:(id)sender {
    // posts convo if needed and makes call to function to save DM
    if (self.noDMs == YES){
        PMConversation *newConvo = [PMConversation new];
        [newConvo postConvo:PFUser.currentUser
                  otherUser:self.receiver withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil){
                NSLog(kPostingErrString);
            } else {
                self.noDMs = NO;
                self.convo = newConvo;
                [self saveDM];
            }
        }];
    } else {
        [self saveDM];
    }

 
}

@end
