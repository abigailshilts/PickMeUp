//
//  cacheTests.m
//  PickMeUpTests
//
//  Created by Abigail Shilts on 7/29/22.
//

#import <XCTest/XCTest.h>
#import "PMConversation.h"
#import "PMCachingFunctions.h"
#import "PMDirectMessage.h"

@interface cacheTests : XCTestCase
@property (nonatomic, strong) PMConversation *firstConvo;
@property (nonatomic, strong) PMConversation *secondConvo;
@property (nonatomic, strong) PMConversation *thirdConvo;
@property (nonatomic, strong) PMConversation *fourthConvo;
@property (nonatomic, strong) PMConversation *fifthConvo;
@property (nonatomic, strong) PMDirectMessage *convoOneDMOne;
@property (nonatomic, strong) PMDirectMessage *convoOneDMTwo;
@property (nonatomic, strong) PMDirectMessage *convoOneDMThree;
@property (nonatomic, strong) PMDirectMessage *convoOneDMFour;
@property (nonatomic, strong) PMDirectMessage *convoTwoDMOne;
@property (nonatomic, strong) PMDirectMessage *convoTwoDMTwo;
@property (nonatomic, strong) PMDirectMessage *convoTwoDMThree;
@end

@implementation cacheTests

static const NSString *const kConversationCacheFile = @"ConversationCache.plist";
static const NSString *const kDMCacheFile = @"DMCache.plist";
static const NSString *const kDMCache = @"DMCache";
static const NSString *const kDotPlist = @".plist";

- (void)setUp {
    self.firstConvo = [PMConversation new];
    self.secondConvo = [PMConversation new];
    self.thirdConvo = [PMConversation new];
    self.fourthConvo = [PMConversation new];
    self.fifthConvo = [PMConversation new];

    self.firstConvo.objectId = @"lsjfbqjlfb";
    self.secondConvo.objectId = @"wefjfbnp1";
    self.thirdConvo.objectId = @"nvnveuirno";
    self.fourthConvo.objectId = @"aasfniiwn";
    self.fifthConvo.objectId = @"qwertyuiop";

    self.firstConvo.receiver = PFUser.currentUser;
    self.secondConvo.receiver = PFUser.currentUser;
    self.thirdConvo.sender = PFUser.currentUser;
    self.fourthConvo.sender = PFUser.currentUser;
    self.fifthConvo.sender = PFUser.currentUser;

    PFUser *xyz = [PFUser new];
    PFUser *abc = [PFUser new];
    PFUser *fgh = [PFUser new];
    PFUser *lmn = [PFUser new];
    PFUser *opq = [PFUser new];

    xyz.username = @"xyz";
    abc.username = @"abc";
    fgh.username = @"fgh";
    lmn.username = @"lmn";
    opq.username = @"opq";

    self.firstConvo.sender = xyz;
    self.secondConvo.sender = abc;
    self.thirdConvo.receiver = fgh;
    self.fourthConvo.receiver = lmn;
    self.fifthConvo.receiver = opq;

    self.convoOneDMOne = [PMDirectMessage new];
    self.convoOneDMTwo = [PMDirectMessage new];
    self.convoOneDMThree = [PMDirectMessage new];
    self.convoOneDMFour = [PMDirectMessage new];

    self.convoOneDMOne.objectId = @"nvjnvjnrj";
    self.convoOneDMTwo.objectId = @"iqmopwehr";
    self.convoOneDMThree.objectId = @"utrbijniq";
    self.convoOneDMFour.objectId = @"fyuvohjsdn";

    self.convoOneDMOne.sender = PFUser.currentUser;
    self.convoOneDMTwo.sender = PFUser.currentUser;
    self.convoOneDMThree.sender = xyz;
    self.convoOneDMFour.sender = xyz;

    self.convoOneDMOne.content = @"howdy";
    self.convoOneDMTwo.content = @"sup";
    self.convoOneDMThree.content = @"yuh";
    self.convoOneDMFour.content = @"ugh";

    self.convoOneDMOne.convoId = @"lsjfbqjlfb";
    self.convoOneDMTwo.convoId = @"lsjfbqjlfb";
    self.convoOneDMThree.convoId = @"lsjfbqjlfb";
    self.convoOneDMFour.convoId = @"lsjfbqjlfb";

    self.convoTwoDMOne = [PMDirectMessage new];
    self.convoTwoDMTwo = [PMDirectMessage new];
    self.convoTwoDMThree = [PMDirectMessage new];

    self.convoTwoDMOne.objectId = @"cvbnmdfghj";
    self.convoTwoDMTwo.objectId = @"sdfgghjxcv";
    self.convoTwoDMThree.objectId = @"wertdfgc";

    self.convoTwoDMOne.sender = PFUser.currentUser;
    self.convoTwoDMTwo.sender = PFUser.currentUser;
    self.convoTwoDMThree.sender = abc;

    self.convoTwoDMOne.content = @"ope";
    self.convoTwoDMTwo.content = @"lol";
    self.convoTwoDMThree.content = @"yeah";

    self.convoTwoDMOne.convoId = @"wefjfbnp1";
    self.convoTwoDMTwo.convoId = @"wefjfbnp1";
    self.convoTwoDMThree.convoId = @"wefjfbnp1";
}

// When cache is empty
- (void)testEmptyConvos {
    NSMutableArray<PMConversation *> *toAdd = [NSMutableArray new];
    [toAdd addObject:self.firstConvo];
    [toAdd addObject:self.secondConvo];
    [toAdd addObject:self.thirdConvo];
    [toAdd addObject:self.fourthConvo];

    [PMCachingFunctions updateConversationCache:toAdd];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kConversationCacheFile];
    NSMutableArray<NSDictionary *> *savedValue = [[NSMutableArray alloc] initWithContentsOfFile: plistPath];

    for (int i = 0; i < savedValue.count; i++) {
        XCTAssertEqualObjects(toAdd[i].objectId, savedValue[i][@"objectId"]);
        XCTAssertEqualObjects(toAdd[i].sender.username, savedValue[i][@"sender"]);
        XCTAssertEqualObjects(toAdd[i].receiver.username, savedValue[i][@"receiver"]);
    }

}

// When cache needs to be added to
- (void)testUpdateConvos {
    NSMutableArray<PMConversation *> *toAdd = [NSMutableArray new];
    [toAdd addObject:self.firstConvo];
    [toAdd addObject:self.secondConvo];
    [toAdd addObject:self.thirdConvo];
    [toAdd addObject:self.fourthConvo];
    [toAdd addObject:self.fifthConvo];

    [PMCachingFunctions updateConversationCache:toAdd];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kConversationCacheFile];
    NSMutableArray<NSDictionary *> *savedValue = [[NSMutableArray alloc] initWithContentsOfFile: plistPath];

    for (int i = 0; i < savedValue.count; i++) {
        XCTAssertEqualObjects(toAdd[i].objectId, savedValue[i][@"objectId"]);
        XCTAssertEqualObjects(toAdd[i].sender.username, savedValue[i][@"sender"]);
        XCTAssertEqualObjects(toAdd[i].receiver.username, savedValue[i][@"receiver"]);
    }
}

// Retrieving from cache
- (void)testRetrieveConvos {
    NSArray<PMConversation *> *recieved = [PMCachingFunctions retreiveConversationCache];
    NSMutableArray<PMConversation *> *toComp = [NSMutableArray new];
    [toComp addObject:self.firstConvo];
    [toComp addObject:self.secondConvo];
    [toComp addObject:self.thirdConvo];
    [toComp addObject:self.fourthConvo];
    [toComp addObject:self.fifthConvo];

    for (int i = 0; i < recieved.count; i++) {
        XCTAssertEqualObjects(recieved[i].objectId, toComp[i].objectId);
        XCTAssertEqualObjects(recieved[i].sender.username, toComp[i].sender.username);
        XCTAssertEqualObjects(recieved[i].receiver.username, toComp[i].receiver.username);
    }
}

// Saving DMs to empty DM cache
- (void)testSaveToEmptyDMs {
    NSMutableArray<PMDirectMessage *> *toAdd = [NSMutableArray new];
    [toAdd addObject:self.convoOneDMOne];
    [toAdd addObject:self.convoOneDMTwo];
    [toAdd addObject:self.convoOneDMThree];

    [PMCachingFunctions updateDMCache:toAdd conversation:self.firstConvo];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kDMCache];
    plistPath = [plistPath stringByAppendingString:PFUser.currentUser.objectId];
    plistPath = [plistPath stringByAppendingString:kDotPlist];
    NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSArray<NSDictionary *> *DMs = savedValue[self.firstConvo.objectId];

    for (int i = 0; i < toAdd.count; i++) {
        XCTAssertEqualObjects(toAdd[i].objectId, DMs[i][@"objectId"]);
        XCTAssertEqualObjects(toAdd[i].sender.username, DMs[i][@"sender"]);
        XCTAssertEqualObjects(toAdd[i].content, DMs[i][@"content"]);
        XCTAssertEqualObjects(toAdd[i].convoId, DMs[i][@"convoId"]);
    }

}

// Saving DMs from new convo to non-empty DM cache
- (void)testSaveNewConvoDMs {
    NSMutableArray<PMDirectMessage *> *toAdd = [NSMutableArray new];
    [toAdd addObject:self.convoTwoDMOne];
    [toAdd addObject:self.convoTwoDMTwo];
    [toAdd addObject:self.convoTwoDMThree];

    [PMCachingFunctions updateDMCache:toAdd conversation:self.secondConvo];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kDMCache];
    plistPath = [plistPath stringByAppendingString:PFUser.currentUser.objectId];
    plistPath = [plistPath stringByAppendingString:kDotPlist];
    NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSArray<NSDictionary *> *DMsOne = savedValue[self.firstConvo.objectId];
    NSArray<NSDictionary *> *DMsTwo = savedValue[self.secondConvo.objectId];


    NSMutableArray<PMDirectMessage *> *toComp = [NSMutableArray new];
    [toComp addObject:self.convoOneDMOne];
    [toComp addObject:self.convoOneDMTwo];
    [toComp addObject:self.convoOneDMThree];

    for (int i = 0; i < toAdd.count; i++) {
        XCTAssertEqualObjects(toComp[i].objectId, DMsOne[i][@"objectId"]);
        XCTAssertEqualObjects(toComp[i].sender.username, DMsOne[i][@"sender"]);
        XCTAssertEqualObjects(toComp[i].content, DMsOne[i][@"content"]);
        XCTAssertEqualObjects(toComp[i].convoId, DMsOne[i][@"convoId"]);
    }
    for (int i = 0; i < DMsTwo.count; i++) {
        XCTAssertEqualObjects(toAdd[i].objectId, DMsTwo[i][@"objectId"]);
        XCTAssertEqualObjects(toAdd[i].sender.username, DMsTwo[i][@"sender"]);
        XCTAssertEqualObjects(toAdd[i].content, DMsTwo[i][@"content"]);
        XCTAssertEqualObjects(toAdd[i].convoId, DMsTwo[i][@"convoId"]);
    }

}

// Saving new DMs to current Convo/DM cache
- (void)testSaveDMsToCurrentConvo {
    NSMutableArray<PMDirectMessage *> *toAdd = [NSMutableArray new];
    [toAdd addObject:self.convoOneDMOne];
    [toAdd addObject:self.convoOneDMTwo];
    [toAdd addObject:self.convoOneDMThree];
    [toAdd addObject:self.convoOneDMFour];

    [PMCachingFunctions updateDMCache:toAdd conversation:self.firstConvo];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kDMCache];
    plistPath = [plistPath stringByAppendingString:PFUser.currentUser.objectId];
    plistPath = [plistPath stringByAppendingString:kDotPlist];
    NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    NSArray<NSDictionary *> *DMsOne = savedValue[self.firstConvo.objectId];
    NSArray<NSDictionary *> *DMsTwo = savedValue[self.secondConvo.objectId];


    NSMutableArray<PMDirectMessage *> *toComp = [NSMutableArray new];
    [toComp addObject:self.convoTwoDMOne];
    [toComp addObject:self.convoTwoDMTwo];
    [toComp addObject:self.convoTwoDMThree];

    for (int i = 0; i < DMsTwo.count; i++) {
        XCTAssertEqualObjects(toComp[i].objectId, DMsTwo[i][@"objectId"]);
        XCTAssertEqualObjects(toComp[i].sender.username, DMsTwo[i][@"sender"]);
        XCTAssertEqualObjects(toComp[i].content, DMsTwo[i][@"content"]);
        XCTAssertEqualObjects(toComp[i].convoId, DMsTwo[i][@"convoId"]);
    }
    for (int i = 0; i < DMsTwo.count; i++) {
        XCTAssertEqualObjects(toAdd[i].objectId, DMsOne[i][@"objectId"]);
        XCTAssertEqualObjects(toAdd[i].sender.username, DMsOne[i][@"sender"]);
        XCTAssertEqualObjects(toAdd[i].content, DMsOne[i][@"content"]);
        XCTAssertEqualObjects(toAdd[i].convoId, DMsOne[i][@"convoId"]);
    }

}

// Retrieving DMs
- (void)testRetrieveDM {
    NSMutableArray<PMDirectMessage *> *toComp = [NSMutableArray new];
    [toComp addObject:self.convoOneDMOne];
    [toComp addObject:self.convoOneDMTwo];
    [toComp addObject:self.convoOneDMThree];
    [toComp addObject:self.convoOneDMFour];

    NSArray<PMDirectMessage *> *convoCache = [PMCachingFunctions translateDMs:self.firstConvo];

    for (int i = 0; i < convoCache.count; i++) {
        XCTAssertEqualObjects(toComp[i].objectId, convoCache[i].objectId);
        XCTAssertEqualObjects(toComp[i].sender.username, convoCache[i].sender.username);
        XCTAssertEqualObjects(toComp[i].content, convoCache[i].content);
        XCTAssertEqualObjects(toComp[i].convoId, convoCache[i].convoId);
    }

    NSMutableArray<PMDirectMessage *> *toCompTwo = [NSMutableArray new];
    [toCompTwo addObject:self.convoTwoDMOne];
    [toCompTwo addObject:self.convoTwoDMTwo];
    [toCompTwo addObject:self.convoTwoDMThree];

    NSArray<PMDirectMessage *> *convoTwoCache = [PMCachingFunctions translateDMs:self.firstConvo];

    for (int i = 0; i < convoCache.count; i++) {
        XCTAssertEqualObjects(toComp[i].objectId, convoTwoCache[i].objectId);
        XCTAssertEqualObjects(toComp[i].sender.username, convoTwoCache[i].sender.username);
        XCTAssertEqualObjects(toComp[i].content, convoTwoCache[i].content);
        XCTAssertEqualObjects(toComp[i].convoId, convoTwoCache[i].convoId);
    }
}

@end
