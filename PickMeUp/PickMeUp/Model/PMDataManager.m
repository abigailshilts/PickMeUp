//
//  PMDataManager.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/27/22.
//
#import "Parse/Parse.h"
#import "PMCachingFunctions.h"
#import "PMDataManager.h"
#import "PMTree.h"
#import "StringsList.h"

@interface PMDataManager ()
@property (nonatomic, copy) void (^completionBlock)(NSArray<PMConversation *> *);
@property (nonatomic, strong) NSMutableArray<PMDirectMessage*> *directMessages;
@end

@implementation PMDataManager

static const NSString *const kConvoIdKey = @"convoId";
static const int kPageSize = 30;

+ (id)dataManager {
    static PMDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    return dataManager;
}

/**
 * Saves 30 most recent DMs in a conversation to the plist cache when a conversation is closed (overwrites previously contained ones)
 * @param toSave total loaded array of DMs in the conversation at time of VC closure
 * @param idToSave conversation id associated with the DMs being saved so that they can be retrieved in future
 */
-(void)saveDMs:(NSArray<PMDirectMessage *> *)toSave conversation:(NSString *)idToSave {
    NSArray<PMDirectMessage *> *toCache;
    if (toSave.count > kPageSize) {
        NSRange range;
        range.location = 0;
        range.length = kPageSize;
        toCache = [toSave subarrayWithRange:range];
    } else {
        toCache = toSave;
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [PMCachingFunctions updateDMCache:toCache conversation:idToSave];
    });
}

/**
 * Retrieves DMs relevant to current conversation
 * @param idToSearch the convo id associated with the DMs for that conversation and their key in the plist cache
 * @param completionBlock uses completion block to first return DMs from plist cache
 * then is called a second time update with DMs from query if cache isn't up to date
 */
-(void)fillDMs:(NSString *)idToSearch withBlock:(void(^)(NSArray<PMDirectMessage *> *))completionBlock {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.completionBlock = completionBlock;
        self.directMessages = [PMCachingFunctions translateDMs:idToSearch];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (self.completionBlock == nil) {
                return;
            }
            self.completionBlock(self.directMessages);
        });
        [self _runGetDMsQuery:idToSearch];
    });
}

/**
 * Retrieves all conversation object the current user is apart of
 * @param completionBlock called a first time to return contents of conversation cache,
 * then if cache is not upto date with query call will call again to update with the additional conversation objects
 */
-(void)fillConversations:(void(^)(NSArray<PMConversation *> *))completionBlock {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.completionBlock = completionBlock;
        self.conversations = [PMCachingFunctions retreiveConversationCache];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (self.completionBlock == nil) {
                return;
            }
            self.completionBlock(self.conversations);
        });
        [self _runGetQuery];
    });
}

/**
 * Queries the database for conversations involving the current user
 */
-(void)_runGetQuery {
    PFUser *currentUser = PFUser.currentUser;
    // Populates conversation array
    // builds query to search for currentUser in either user1 or user2
    PFQuery *user1 = [PFQuery queryWithClassName:kConversationClassName];
    [user1 whereKey:kSenderKey equalTo:currentUser];
    PFQuery *user2 = [PFQuery queryWithClassName:kConversationClassName];
    [user2 whereKey:kReceiverKey equalTo:currentUser];
    PFQuery *toQuery = [PFQuery orQueryWithSubqueries:@[user1, user2]];
    [toQuery findObjectsInBackgroundWithBlock:^(NSArray *convos, NSError *error) {
        if (convos != nil) {
            /* Making this check because there likely won't be new conversations between different
            times accessing this VC */
            if (convos.count > self.conversations.count) {
                NSMutableArray<PMConversation *> *toUpdateWith = [NSMutableArray new];
                for (int i = 0; i < convos.count-self.conversations.count; i++) {
                    [toUpdateWith addObject:convos[i]];
                }
                self.conversations = convos;
                [PMCachingFunctions updateConversationCache:self.conversations];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    // Only returning new conversations so that the tree doesn't have to be recreated or have doubles
                    if (self.completionBlock == nil) {
                        return;
                    }
                    self.completionBlock(toUpdateWith);
                });
            }
        }
    }];
}

/**
 * Queries the database for most recent DMs in the current conversation
 * @param idToSearch the conversation id associated with desired DMs
 */
-(void)_runGetDMsQuery:(NSString *)idToSearch {
    // Populates DM array
    PFQuery *getQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
    [getQuery whereKey:kConvoIdKey equalTo:idToSearch];
    [getQuery orderByDescending:kCreatedAtKey];
    [getQuery findObjectsInBackgroundWithBlock:^(NSArray *DMs, NSError *error) {
        // Checking query ran properly
        if (DMs != nil) {
            self.directMessages = DMs;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (self.completionBlock == nil) {
                    return;
                }
                self.completionBlock(self.directMessages);
            });
        }
    }];
}

/**
 * Queries the database for additional DMs in conversation after user has scrolled to the bottom of loaded DMs
 * @param idToSearch the conversation id associated with desired DMs
 * @param pageCount the number of pages of DMs already queried
 * @param completionBlock block for returning retrieved DMs
 */
-(void)loadMoreDMs:(NSString *)idToSearch pageCount:(NSInteger)pageCount
          withBlock:(void(^)(NSArray<PMDirectMessage *> *))completionBlock {
    // Populates DM array
    PFQuery *getQuery = [PFQuery queryWithClassName:kDirectMessageClassName];
    [getQuery whereKey:kConvoIdKey equalTo:idToSearch];
    getQuery.limit = kPageSize;
    [getQuery orderByDescending:kCreatedAtKey];
    if (self.directMessages.count > 0) {
        getQuery.skip = pageCount*kPageSize;
    }
    [getQuery findObjectsInBackgroundWithBlock:^(NSArray *DMs, NSError *error) {
        if (DMs != nil && completionBlock != nil) {
            completionBlock(DMs);
        }
    }];
}

@end
