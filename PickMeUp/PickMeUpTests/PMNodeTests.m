//
//  PMNodeTests.m
//  PickMeUpTests
//
//  Created by Abigail Shilts on 7/21/22.
//

#import <XCTest/XCTest.h>
#import "PMNode.h"

@interface PMNodeTests : XCTestCase
@property (nonatomic, strong) PMNode *testingEmptChildren;
@property (nonatomic, strong) PMNode *testingOneChild;
@property (nonatomic, strong) PMNode *testingTwoChildren;

@end

@implementation PMNodeTests

- (void)setUp {
    self.testingEmptChildren = [PMNode new];
    self.testingOneChild = [PMNode new];
    self.testingTwoChildren = [PMNode new];
    
    self.testingEmptChildren.prefix = @"abc";
    self.testingOneChild.prefix = @"abd";
    self.testingTwoChildren.prefix = @"abe";
}

// Test focusing on adding a node to an empty child array
- (void)testWhenEmpty {
    PMNode *toAdd = [PMNode new];
    toAdd.prefix = @"abcd";
    [self.testingEmptChildren setChild:toAdd];
    NSMutableArray<PMNode *> *testingAgainst = [NSMutableArray array];
    [testingAgainst addObject:toAdd];
    NSArray<PMNode *> *testingFor = [self.testingEmptChildren getChildren];
    XCTAssertEqual(testingFor.count, testingAgainst.count);
    int i;
    for (i = 0; i < testingFor.count; i++) {
        XCTAssertEqualObjects(testingFor[i], testingAgainst[i]);
    }
}

// Test focusing on correct adding of nodes to child array when it is two nodes added in alphabetical order
-(void)testWithOneAlphabetically {
    PMNode *toAdd = [PMNode new];
    toAdd.prefix = @"abda";
    PMNode *toAddAgain = [PMNode new];
    toAddAgain.prefix = @"abdb";
    [self.testingOneChild setChild:toAdd];
    [self.testingOneChild setChild:toAddAgain];
    NSMutableArray<PMNode *> *testingAgainst = [NSMutableArray array];
    [testingAgainst addObject:toAdd];
    [testingAgainst addObject:toAddAgain];
    NSArray<PMNode *> *testingFor = [self.testingOneChild getChildren];
    XCTAssertEqual(testingFor.count, testingAgainst.count);
    int i;
    for (i = 0; i < testingFor.count; i++) {
        XCTAssertEqualObjects(testingFor[i], testingAgainst[i]);
    }
}

// Test focusing on correct adding of nodes to child array when it is two nodes added in reverse alphabetical order
-(void)testWithOneNonAlphabetically {
    PMNode *toAdd = [PMNode new];
    toAdd.prefix = @"abdb";
    PMNode *toAddAgain = [PMNode new];
    toAddAgain.prefix = @"abda";
    [self.testingOneChild setChild:toAdd];
    [self.testingOneChild setChild:toAddAgain];

    NSMutableArray<PMNode *> *testingAgainst = [NSMutableArray array];
    [testingAgainst addObject:toAddAgain];
    [testingAgainst addObject:toAdd];
    NSArray<PMNode *> *testingFor = [self.testingOneChild getChildren];
    XCTAssertEqual(testingFor.count, testingAgainst.count);
    int i;
    for (i = 0; i < testingFor.count; i++) {
        XCTAssertEqualObjects(testingFor[i], testingAgainst[i]);
    }
}

/*
* Test focusing on correct adding of nodes to child array when it is three nodes
* and the last one added is alphabetically first
*/
-(void)testWithTwoInFront {
    PMNode *toAdd = [PMNode new];
    toAdd.prefix = @"abeb";
    PMNode *toAddAgain = [PMNode new];
    toAddAgain.prefix = @"abec";
    [self.testingOneChild setChild:toAdd];
    [self.testingOneChild setChild:toAddAgain];
    
    PMNode *toAddToFront = [PMNode new];
    toAddToFront.prefix = @"abea";
    [self.testingOneChild setChild:toAddToFront];
    
    NSMutableArray<PMNode *> *testingAgainst = [NSMutableArray array];
    [testingAgainst addObject:toAddToFront];
    [testingAgainst addObject:toAdd];
    [testingAgainst addObject:toAddAgain];
    
    NSArray<PMNode *> *testingFor = [self.testingOneChild getChildren];
    XCTAssertEqual(testingFor.count, testingAgainst.count);
    int i;
    for (i = 0; i < testingFor.count; i++) {
        XCTAssertEqualObjects(testingFor[i], testingAgainst[i]);
    }
}

/*
* Test focusing on correct adding of nodes to child array when it is three nodes
* and the last one added is alphabetically second
*/
-(void)testWithTwoInMiddle {
    PMNode *toAdd = [PMNode new];
    toAdd.prefix = @"abea";
    PMNode *toAddAgain = [PMNode new];
    toAddAgain.prefix = @"abec";
    [self.testingOneChild setChild:toAdd];
    [self.testingOneChild setChild:toAddAgain];
    
    PMNode *toAddToMiddle = [PMNode new];
    toAddToMiddle.prefix = @"abeb";
    [self.testingOneChild setChild:toAddToMiddle];
    
    NSMutableArray<PMNode *> *testingAgainst = [NSMutableArray array];
    [testingAgainst addObject:toAdd];
    [testingAgainst addObject:toAddToMiddle];
    [testingAgainst addObject:toAddAgain];
    
    NSArray<PMNode *> *testingFor = [self.testingOneChild getChildren];
    XCTAssertEqual(testingFor.count, testingAgainst.count);
    int i;
    for (i = 0; i < testingFor.count; i++) {
        XCTAssertEqualObjects(testingFor[i], testingAgainst[i]);
    }
}

/*
* Test focusing on correct adding of nodes to child array when it is three nodes
* and the last one added is alphabetically last
*/
-(void)testWithTwoInEnd {
    PMNode *toAdd = [PMNode new];
    toAdd.prefix = @"abea";
    PMNode *toAddAgain = [PMNode new];
    toAddAgain.prefix = @"abeb";
    [self.testingOneChild setChild:toAdd];
    [self.testingOneChild setChild:toAddAgain];
    
    PMNode *toAddToEnd = [PMNode new];
    toAddToEnd.prefix = @"abec";
    [self.testingOneChild setChild:toAddToEnd];
    
    NSMutableArray<PMNode *> *testingAgainst = [NSMutableArray array];
    [testingAgainst addObject:toAdd];
    [testingAgainst addObject:toAddAgain];
    [testingAgainst addObject:toAddToEnd];
    
    NSArray<PMNode *> *testingFor = [self.testingOneChild getChildren];
    XCTAssertEqual(testingFor.count, testingAgainst.count);
    int i;
    for (i = 0; i < testingFor.count; i++) {
        XCTAssertEqualObjects(testingFor[i], testingAgainst[i]);
    }
}

@end
