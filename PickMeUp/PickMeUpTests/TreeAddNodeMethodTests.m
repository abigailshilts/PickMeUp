//
//  TreeAddNodeMethodTests.m
//  PickMeUpTests
//
//  Created by Abigail Shilts on 7/22/22.
//

#import <XCTest/XCTest.h>
#import "PMNode.h"
#import "PMTree.h"
#import "PMConversation.h"

@interface TreeAddNodeMethodTests : XCTestCase
@property (nonatomic, strong) PMTree *testTree;
@property (nonatomic, strong) PMTree *testEmpt;
@end

@implementation TreeAddNodeMethodTests

- (void)setUp {
    self.testTree = [PMTree new];
    self.testEmpt = [PMTree new];
    
    PMNode *lengthOneFirst = [PMNode new];
    PMNode *lengthOneSecond = [PMNode new];
    PMNode *lengthOneThird = [PMNode new];
    PMNode *lengthOneFourth = [PMNode new];
    
    lengthOneFirst.prefix = @"a";
    lengthOneSecond.prefix = @"c";
    lengthOneThird.prefix = @"e";
    lengthOneFourth.prefix = @"f";
    
    PMNode *lengthTwoFirst = [PMNode new];
    PMNode *lengthTwoSecond = [PMNode new];
    PMNode *lengthTwoThird = [PMNode new];
    PMNode *lengthTwoFourth = [PMNode new];
    PMNode *lengthTwoFifth = [PMNode new];
    PMNode *lengthTwoSixth = [PMNode new];
    PMNode *lengthTwoSeventh = [PMNode new];
    PMNode *lengthTwoEigth = [PMNode new];
    PMNode *lengthTwoNineth = [PMNode new];
    
    lengthTwoFirst.prefix = @"aa";
    lengthTwoSecond.prefix = @"ab";
    lengthTwoThird.prefix = @"ad";
    lengthTwoFourth.prefix = @"ca";
    lengthTwoFifth.prefix = @"cf";
    lengthTwoSixth.prefix = @"cz";
    lengthTwoSeventh.prefix = @"ef";
    lengthTwoEigth.prefix = @"eg";
    lengthTwoNineth.prefix = @"fg";
    
    PMNode *lengthThreeFirst = [PMNode new];
    PMNode *lengthThreeSecond = [PMNode new];
    PMNode *lengthThreeThird = [PMNode new];
    PMNode *lengthThreeFourth = [PMNode new];
    PMNode *lengthThreeFifth = [PMNode new];
    PMNode *lengthThreeSixth = [PMNode new];
    PMNode *lengthThreeSeventh = [PMNode new];
    
    lengthThreeFirst.prefix = @"aa!";
    lengthThreeSecond.prefix = @"aaa";
    lengthThreeThird.prefix = @"ad1";
    lengthThreeFourth.prefix = @"caa";
    lengthThreeFifth.prefix = @"cab";
    lengthThreeSixth.prefix = @"cfz";
    lengthThreeSeventh.prefix = @"egg";
    
    PMNode *lengthFourFirst = [PMNode new];
    PMNode *lengthFourSecond = [PMNode new];
    
    lengthFourFirst.prefix = @"cab*";
    lengthFourSecond.prefix = @"cabs";
    
    // setChildMethod tested for accuracy in PMNodeTests file
    [lengthThreeFifth setChild:lengthFourFirst];
    [lengthThreeFifth setChild:lengthFourSecond];
    
    [lengthTwoFirst setChild:lengthThreeFirst];
    [lengthTwoFirst setChild:lengthThreeSecond];
    [lengthTwoThird setChild:lengthThreeThird];
    [lengthTwoFourth setChild:lengthThreeFourth];
    [lengthTwoFourth setChild:lengthThreeFifth];
    [lengthTwoFifth setChild:lengthThreeSixth];
    [lengthTwoEigth setChild:lengthThreeSeventh];

    [lengthOneFirst setChild:lengthTwoFirst];
    [lengthOneFirst setChild:lengthTwoSecond];
    [lengthOneFirst setChild:lengthTwoThird];
    [lengthOneSecond setChild:lengthTwoFourth];
    [lengthOneSecond setChild:lengthTwoFifth];
    [lengthOneSecond setChild:lengthTwoSixth];
    [lengthOneThird setChild:lengthTwoSeventh];
    [lengthOneThird setChild:lengthTwoEigth];
    [lengthOneFourth setChild:lengthTwoNineth];
    
    [self.testTree.rootNode setChild:lengthOneFirst];
    [self.testTree.rootNode setChild:lengthOneSecond];
    [self.testTree.rootNode setChild:lengthOneThird];
    [self.testTree.rootNode setChild:lengthOneFourth];
}

// tests when convo is the first node to be added to a tree
- (void)testEmptyTree {
    PFUser *toDisplay = [PFUser new];
    toDisplay.username = @"cab";
    PMConversation *toAdd = [PMConversation new];
    toAdd.sender = PFUser.currentUser;
    toAdd.receiver = toDisplay;
    [self.testEmpt addConversation:toAdd];
    
    PMNode *testAgainst = [[[self.testEmpt.rootNode getChildren][0] getChildren][0] getChildren][0];
    XCTAssertEqualObjects(toAdd, testAgainst.payLoad);

}

// tests when the username to display for the conversation being added is already a prefix in the tree for an empty node
- (void)testEmptyNode {
    PFUser *toDisplay = [PFUser new];
    toDisplay.username = @"cab";
    PMConversation *toAdd = [PMConversation new];
    toAdd.sender = PFUser.currentUser;
    toAdd.receiver = toDisplay;
    [self.testTree addConversation:toAdd];
    
    PMNode *testAgainst = [[[self.testTree.rootNode getChildren][1] getChildren][0] getChildren][1];
    XCTAssertEqualObjects(toAdd, testAgainst.payLoad);

}

// tests when the proper parent node already exists
- (void)testProperNode {
    PFUser *toDisplay = [PFUser new];
    toDisplay.username = @"efg";
    PMConversation *toAdd = [PMConversation new];
    toAdd.sender = PFUser.currentUser;
    toAdd.receiver = toDisplay;
    [self.testTree addConversation:toAdd];
    
    PMNode *testAgainst = [[[self.testTree.rootNode getChildren][2] getChildren][0] getChildren][0];
    XCTAssertEqualObjects(toAdd, testAgainst.payLoad);
}

// tests when the closest prefix is significantly shorter
- (void)testNoParentNode {
    PFUser *toDisplay = [PFUser new];
    toDisplay.username = @"fghij";
    PMConversation *toAdd = [PMConversation new];
    toAdd.sender = PFUser.currentUser;
    toAdd.receiver = toDisplay;
    [self.testTree addConversation:toAdd];
    
    PMNode *testAgainstFirst = [[[self.testTree.rootNode getChildren][3] getChildren][0] getChildren][0];
    PMNode *testAgainstSecond = [testAgainstFirst getChildren][0];
    PMNode *testAgainstThird = [testAgainstSecond getChildren][0];
    XCTAssertEqualObjects(@"fgh", testAgainstFirst.prefix);
    XCTAssertEqualObjects(@"fghi", testAgainstSecond.prefix);
    XCTAssertEqual(toAdd, testAgainstThird.payLoad);
}

@end
