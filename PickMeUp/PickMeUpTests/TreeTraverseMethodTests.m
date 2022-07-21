//
//  TreeTraverseMethodTests.m
//  PickMeUpTests
//
//  Created by Abigail Shilts on 7/21/22.
//

#import <XCTest/XCTest.h>
#import "PMNode.h"
#import "PMTree.h"

@interface TreeTraverseMethodTests : XCTestCase
@property (nonatomic, strong) PMTree *testTree;
@end

@implementation TreeTraverseMethodTests

- (void)setUp {
    self.testTree = [PMTree new];
    
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

// tests traverse method when the desired node is one level below
- (void)testRetrievingOneLevelDeep {
    PMNode *firstToFind = [self.testTree.rootNode getChildren][0];
    PMNode *secondToFind = [self.testTree.rootNode getChildren][2];
    
    XCTAssertEqualObjects([self.testTree traverseToNode:@"a" withstartNode:self.testTree.rootNode], firstToFind);
    XCTAssertEqualObjects([self.testTree traverseToNode:@"e" withstartNode:self.testTree.rootNode], secondToFind);

}

// tests traverse method when the desired node is four levels below
- (void)testRetrievingFourLevelsDeep {
    PMNode *thirdLevel = [[[self.testTree.rootNode getChildren][1] getChildren][0] getChildren][1];
    PMNode *firstToFind = [thirdLevel getChildren][0];
    PMNode *secondToFind = [thirdLevel getChildren][1];
    
    XCTAssertEqualObjects([self.testTree traverseToNode:@"cab*" withstartNode:self.testTree.rootNode], firstToFind);
    XCTAssertEqualObjects([self.testTree traverseToNode:@"cabs" withstartNode:self.testTree.rootNode], secondToFind);

}

// tests traverse method when the desired node is leftmost node (also tests for finding the leftmost child)
- (void)testRetrievingLeftMost {
    PMNode *secondLevel = [[self.testTree.rootNode getChildren][0] getChildren][0];
    PMNode *toFind = [secondLevel getChildren][0];
    
    XCTAssertEqualObjects([self.testTree traverseToNode:@"aa!" withstartNode:self.testTree.rootNode], toFind);
}

/*
* tests traverse method when the desired node is rightmost node
* (also tests for finding the rightmost child and when it is the only one in array)
*/
- (void)testRetrievingFourRightMost {
    PMNode *firstLevel = [self.testTree.rootNode getChildren][3];
    PMNode *toFind = [firstLevel getChildren][0];
    
    XCTAssertEqualObjects([self.testTree traverseToNode:@"fg" withstartNode:self.testTree.rootNode], toFind);
}

// tests traverse method when the desired node is in the middle of an array
- (void)testRetrievingMiddle {
    PMNode *firstLevel = [self.testTree.rootNode getChildren][1];
    PMNode *toFind = [firstLevel getChildren][1];
    
    XCTAssertEqualObjects([self.testTree traverseToNode:@"cf" withstartNode:self.testTree.rootNode], toFind);
}

// tests traverse method when the desired node is not in tree
- (void)testRetrievingNonExistant {
    PMNode *secondLevel = [[self.testTree.rootNode getChildren][0] getChildren][0];
    PMNode *toFindFirst = [secondLevel getChildren][0];
    
    PMNode *firstLevel = [self.testTree.rootNode getChildren][2];
    PMNode *toFindSecond = [firstLevel getChildren][0];
    
    XCTAssertEqualObjects([self.testTree traverseToNode:@"aa!!" withstartNode:self.testTree.rootNode], toFindFirst);
    XCTAssertEqualObjects([self.testTree traverseToNode:@"efghi" withstartNode:self.testTree.rootNode], toFindSecond);
}


@end
