//
//  ConversationViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/14/22.
//

#import "ConversationViewController.h"
#import "PMDMCell.h"
#import "DirectMessage.h"
#import "StringsList.h"

@interface ConversationViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *recieverName;
@property (strong, nonatomic) IBOutlet UITextView *messageToSend;
@property (strong, nonatomic) NSMutableArray<DirectMessage *> *arrayOfDMs;
@property BOOL noDMs;
@end

@implementation ConversationViewController

static const NSString *const convoId = @"convoId";
static const NSString *const cellIdentifier = @"DMCell";
static const NSString *const postingErr = @"error on Post request";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recieverName.text = self.reciever.username;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.messageToSend.delegate = self;
    [self getQuery];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }

    [txtView resignFirstResponder];
    return NO;
}

-(void)getQuery {
    // Populates DM array
    if (self.convo == nil) {
        self.noDMs = YES;
    } else {
        self.noDMs = NO;
        PFQuery *getQuery = [PFQuery queryWithClassName:directMessage];
        [getQuery whereKey:convoId equalTo:self.convo.objectId];
        [getQuery findObjectsInBackgroundWithBlock:^(NSArray *DMs, NSError *error) {
            if (DMs != nil) {
                self.arrayOfDMs = DMs;
                [self.tableView reloadData];
            } else {
                NSLog(strInput, error.localizedDescription);
            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMDMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.content.text = self.arrayOfDMs[indexPath.row].content;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDMs.count;
}

-(void)saveDM {
    // posts DM to database and refreshes the table
    DirectMessage *newDM = [DirectMessage new];
    newDM.content = self.messageToSend.text;
    newDM.convoId = self.convo.objectId;
    [newDM postDM:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil){
            NSLog(postingErr);
        } else {
            [self getQuery];
            [self.tableView reloadData];

        }
        self.messageToSend.text = empt;
    }];
}

- (IBAction)didTapSend:(id)sender {
    // posts convo if needed and makes call to function to save DM
    if (self.noDMs == YES){
        Conversation *newConvo = [Conversation new];
        [newConvo postConvo:PFUser.currentUser otherUser:self.reciever withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil){
                NSLog(postingErr);
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
