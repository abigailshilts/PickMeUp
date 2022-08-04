//
//  GroupMessageViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 8/2/22.
//
#import "Parse/Parse.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "PMDataManager.h"
#import "PMDirectMessage.h"
#import "PMGMCell.h"
#import "PMGroupMessageViewController.h"
#import "PMReuseFunctions.h"
#import "StringsList.h"
#import "UIImageView+AFNetworking.h"

@interface PMGroupMessageViewController ()  <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *bio;
@property (strong, nonatomic) IBOutlet UITextView *typeField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFQuery *msgQuery;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;
@property (strong, nonatomic) NSMutableArray<PMDirectMessage *> *arrayToDisplay;
@property (strong, nonatomic) PMDataManager *dataManager;
@property NSInteger pageCount;
@property int totalObjects;
@property int pageObjectNum;
@end

@implementation PMGroupMessageViewController

static const NSString *const kConvoIdKey = @"convoId";
static const NSString *const kCellReuseIdString = @"groupMessageCell";
static const NSString *const kAtString = @"@";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.typeField.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    NSString *link = self.event.image.url;
    NSURL *url = [NSURL URLWithString:link];
    [self.img setImageWithURL:url];
    self.bio.text = self.event.bio;
    self.dataManager = [PMDataManager dataManager];
    [self.dataManager fillDMs:self.event.objectId withBlock:^(NSArray<PMDirectMessage *> *DMs){
        self.arrayToDisplay = DMs;
        [self.tableView reloadData];
    }];
    PFQuery *countQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
    [countQuery whereKey:kConvoIdKey equalTo:self.event.objectId];
    self.pageCount = 1;
    self.totalObjects = [countQuery countObjects];
    self.pageObjectNum = 30;
    self.liveQueryClient = [PMReuseFunctions createLiveQueryObj];
    [self _finishCreatingLiveQuery];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }

    [txtView resignFirstResponder];
    return NO;
}

-(void)_finishCreatingLiveQuery {
    self.msgQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
    [self.msgQuery whereKey:kConvoIdKey equalTo:self.event.objectId];
    self.subscription = [self.liveQueryClient subscribeToQuery:self.msgQuery];
    __weak typeof(self) weakSelf = self;
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.arrayToDisplay insertObject:(PMDirectMessage *)object atIndex:0];
            strongSelf.totalObjects++;
            [strongSelf.tableView reloadData];
        });
    }];
}

- (IBAction)didTapSend:(id)sender {
    self.sendButton.enabled = NO;
    [PMReuseFunctions saveDM:self.typeField.text searchById:self.event.objectId];
    self.typeField.text = kEmpt;
    self.sendButton.enabled = YES;
}

- (IBAction)didTapBack:(id)sender {
    [self.dataManager saveDMs:self.arrayToDisplay conversation:self.event.objectId];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMGMCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdString forIndexPath:indexPath];
    PMDirectMessage *dm = self.arrayToDisplay[indexPath.row];
    [dm.sender fetchIfNeeded];
    cell.message.text = dm.content;
    NSString *username = [kAtString stringByAppendingString:dm.sender.username];
    cell.username.text = username;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayToDisplay.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    int totalPages = (self.totalObjects + self.pageObjectNum)/self.pageObjectNum;
    if (self.pageCount != totalPages){
        if (indexPath.row == self.arrayToDisplay.count-2){
            [self.dataManager loadMoreDMs:self.event.objectId pageCount:self.pageCount withBlock:^(NSArray<PMDirectMessage *> *DMs){
                [self.arrayToDisplay addObjectsFromArray:DMs];
                [self.tableView reloadData];
            }];
            self.pageCount++;
        }
    }
}

@end
