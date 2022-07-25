//
//  TreeRetreiveSubTreeTests.m
//  PickMeUpTests
//
//  Created by Abigail Shilts on 7/22/22.
//

#import <XCTest/XCTest.h>
#import "PMNode.h"
#import "PMTree.h"
#import "PMConversation.h"

@interface TreeRetreiveSubTreeTests : XCTestCase
@property (nonatomic, strong) PMTree *testTree;
@property (nonatomic, strong) PMConversation *a;
@property (nonatomic, strong) PMConversation *c;
@property (nonatomic, strong) PMConversation *e;
@property (nonatomic, strong) PMConversation *f;
@property (nonatomic, strong) PMConversation *aa;
@property (nonatomic, strong) PMConversation *ab;
@property (nonatomic, strong) PMConversation *ad;
@property (nonatomic, strong) PMConversation *ca;
@property (nonatomic, strong) PMConversation *cf;
@property (nonatomic, strong) PMConversation *cz;
@property (nonatomic, strong) PMConversation *ef;
@property (nonatomic, strong) PMConversation *eg;
@property (nonatomic, strong) PMConversation *fg;
@property (nonatomic, strong) PMConversation *aa1;
@property (nonatomic, strong) PMConversation *aaa;
@property (nonatomic, strong) PMConversation *ad1;
@property (nonatomic, strong) PMConversation *caa;
@property (nonatomic, strong) PMConversation *cab;
@property (nonatomic, strong) PMConversation *cfz;
@property (nonatomic, strong) PMConversation *egg;
@property (nonatomic, strong) PMConversation *cab8;
@property (nonatomic, strong) PMConversation *cabs;
@property (nonatomic, strong) PMConversation *efgh;
@property (nonatomic, strong) PMConversation *ad123;
@property (nonatomic, strong) PMConversation *fghij;

@end

@implementation TreeRetreiveSubTreeTests

- (void)setUp {
    self.testTree = [PMTree new];
    
    self.a = [PMConversation new];
    self.a.sender = PFUser.currentUser;
    PFUser *one = [PFUser new];
    one.username = @"a";
    self.a.receiver = one;
    self.c = [PMConversation new];
    self.c.sender = PFUser.currentUser;
    PFUser *two = [PFUser new];
    two.username = @"c";
    self.c.receiver = two;
    self.e = [PMConversation new];
    self.e.sender = PFUser.currentUser;
    PFUser *three = [PFUser new];
    three.username = @"e";
    self.e.receiver = three;
    self.f = [PMConversation new];
    self.f.sender = PFUser.currentUser;
    PFUser *four = [PFUser new];
    four.username = @"f";
    self.f.receiver = four;
    self.aa = [PMConversation new];
    self.aa.sender = PFUser.currentUser;
    PFUser *five = [PFUser new];
    five.username = @"aa";
    self.aa.receiver = five;
    self.ab = [PMConversation new];
    self.ab.sender = PFUser.currentUser;
    PFUser *six = [PFUser new];
    six.username = @"ab";
    self.ab.receiver = six;
    self.ad = [PMConversation new];
    self.ad.sender = PFUser.currentUser;
    PFUser *seven = [PFUser new];
    seven.username = @"ad";
    self.ad.receiver = seven;
    self.ca = [PMConversation new];
    self.ca.sender = PFUser.currentUser;
    PFUser *eight = [PFUser new];
    eight.username = @"ca";
    self.ca.receiver = eight;
    self.cf = [PMConversation new];
    self.cf.sender = PFUser.currentUser;
    PFUser *nine = [PFUser new];
    nine.username = @"cf";
    self.cf.receiver = nine;
    self.cz = [PMConversation new];
    self.cz.sender = PFUser.currentUser;
    PFUser *ten = [PFUser new];
    ten.username = @"cz";
    self.cz.receiver = ten;
    self.ef = [PMConversation new];
    self.ef.sender = PFUser.currentUser;
    PFUser *eleven = [PFUser new];
    eleven.username = @"ef";
    self.ef.receiver = eleven;
    self.eg = [PMConversation new];
    self.eg.sender = PFUser.currentUser;
    PFUser *twelve = [PFUser new];
    twelve.username = @"eg";
    self.eg.receiver = twelve;
    self.fg = [PMConversation new];
    self.fg.sender = PFUser.currentUser;
    PFUser *thirteen = [PFUser new];
    thirteen.username = @"fg";
    self.fg.receiver = thirteen;
    self.aa1 = [PMConversation new];
    self.aa1.receiver = PFUser.currentUser;
    PFUser *fourteen = [PFUser new];
    fourteen.username = @"aa!";
    self.aa1.sender = fourteen;
    self.aaa = [PMConversation new];
    self.aaa.receiver = PFUser.currentUser;
    PFUser *fifteen = [PFUser new];
    fifteen.username = @"aaa";
    self.aaa.sender = fifteen;
    self.ad1 = [PMConversation new];
    self.ad1.receiver = PFUser.currentUser;
    PFUser *sixteen = [PFUser new];
    sixteen.username = @"ad1";
    self.ad1.sender = sixteen;
    self.caa = [PMConversation new];
    self.caa.receiver = PFUser.currentUser;
    PFUser *seventeen = [PFUser new];
    seventeen.username = @"caa";
    self.caa.sender = seventeen;
    self.cab = [PMConversation new];
    self.cab.receiver = PFUser.currentUser;
    PFUser *eighteen = [PFUser new];
    eighteen.username = @"cab";
    self.cab.sender = eighteen;
    self.cfz = [PMConversation new];
    self.cfz.receiver = PFUser.currentUser;
    PFUser *nineteen = [PFUser new];
    nineteen.username = @"cfz";
    self.cfz.sender = nineteen;
    self.egg = [PMConversation new];
    self.egg.receiver = PFUser.currentUser;
    PFUser *twenty = [PFUser new];
    twenty.username = @"egg";
    self.egg.sender = twenty;
    self.cab8 = [PMConversation new];
    self.cab8.receiver = PFUser.currentUser;
    PFUser *twentyone = [PFUser new];
    twentyone.username = @"cab*";
    self.cab8.sender = twentyone;
    self.cabs = [PMConversation new];
    self.cabs.receiver = PFUser.currentUser;
    PFUser *twentytwo = [PFUser new];
    twentytwo.username = @"cabs";
    self.cabs.sender = twentytwo;
    self.efgh = [PMConversation new];
    self.efgh.receiver = PFUser.currentUser;
    PFUser *twentythree = [PFUser new];
    twentythree.username = @"efgh";
    self.efgh.sender = twentythree;
    self.ad123 = [PMConversation new];
    self.ad123.receiver = PFUser.currentUser;
    PFUser *twentyfour = [PFUser new];
    twentyfour.username = @"ad123";
    self.ad123.sender = twentyfour;
    self.fghij = [PMConversation new];
    self.fghij.receiver = PFUser.currentUser;
    PFUser *twentyfive = [PFUser new];
    twentyfive.username = @"fghij";
    self.fghij.sender = twentyfive;
    
    [self.testTree addConversation:self.a];
    [self.testTree addConversation:self.c];
    [self.testTree addConversation:self.e];
    [self.testTree addConversation:self.f];
    [self.testTree addConversation:self.aa];
    [self.testTree addConversation:self.ab];
    [self.testTree addConversation:self.ad];
    [self.testTree addConversation:self.ca];
    [self.testTree addConversation:self.cf];
    [self.testTree addConversation:self.cz];
    [self.testTree addConversation:self.ef];
    [self.testTree addConversation:self.eg];
    [self.testTree addConversation:self.fg];
    [self.testTree addConversation:self.aa1];
    [self.testTree addConversation:self.aaa];
    [self.testTree addConversation:self.ad1];
    [self.testTree addConversation:self.caa];
    [self.testTree addConversation:self.cab];
    [self.testTree addConversation:self.cfz];
    [self.testTree addConversation:self.egg];
    [self.testTree addConversation:self.cab8];
    [self.testTree addConversation:self.cabs];
    [self.testTree addConversation:self.ad123];
    [self.testTree addConversation:self.efgh];
    [self.testTree addConversation:self.fghij];
}

// tests when given prefix is already a leaf
- (void)testLeaf {
    NSMutableArray<PMConversation *> *testAgainst = [NSMutableArray new];
    [testAgainst addObject:self.cabs];
    
    NSArray<PMConversation *> *testing = [self.testTree retreiveSubTree:@"cabs"];
    for (int i = 0; i < testAgainst.count; i++){
        XCTAssertEqualObjects(testing[i], testAgainst[i]);
    }
}

// tests when given prefix has only 1 other element in subtree
-(void)testAlmostLeaf {
    NSMutableArray<PMConversation *> *testAgainst = [NSMutableArray new];
    [testAgainst addObject:self.f];
    [testAgainst addObject:self.fg];
    
    NSArray<PMConversation *> *testing = [self.testTree retreiveSubTree:@"f"];
    for (int i = 0; i < testAgainst.count; i++){
        XCTAssertEqualObjects(testing[i], testAgainst[i]);
    }
}

// tests when given prefix has only 1 level below it
-(void)testAlmostLastLevel {
    NSMutableArray<PMConversation *> *testAgainst = [NSMutableArray new];
    [testAgainst addObject:self.cab];
    [testAgainst addObject:self.cab8];
    [testAgainst addObject:self.cabs];
    
    NSArray<PMConversation *> *testing = [self.testTree retreiveSubTree:@"cab"];
    for (int i = 0; i < testAgainst.count; i++){
        XCTAssertEqualObjects(testing[i], testAgainst[i]);
    }
}

// tests when given prefix is in the middle of a tree
-(void)testMiddle {
    NSMutableArray<PMConversation *> *testAgainst = [NSMutableArray new];
    [testAgainst addObject:self.ca];
    [testAgainst addObject:self.caa];
    [testAgainst addObject:self.cab];
    [testAgainst addObject:self.cab8];
    [testAgainst addObject:self.cabs];
    
    NSArray<PMConversation *> *testing = [self.testTree retreiveSubTree:@"ca"];
    for (int i = 0; i < testAgainst.count; i++){
        XCTAssertEqualObjects(testing[i], testAgainst[i]);
    }
}

// tests when given prefix is tree root also tests when has to bypass empty nodes
-(void)testEntireTree {
    NSMutableArray<PMConversation *> *testAgainst = [NSMutableArray new];
    [testAgainst addObject:self.a];
    [testAgainst addObject:self.c];
    [testAgainst addObject:self.e];
    [testAgainst addObject:self.f];
    [testAgainst addObject:self.aa];
    [testAgainst addObject:self.ab];
    [testAgainst addObject:self.ad];
    [testAgainst addObject:self.ca];
    [testAgainst addObject:self.cf];
    [testAgainst addObject:self.cz];
    [testAgainst addObject:self.ef];
    [testAgainst addObject:self.eg];
    [testAgainst addObject:self.fg];
    [testAgainst addObject:self.aa1];
    [testAgainst addObject:self.aaa];
    [testAgainst addObject:self.ad1];
    [testAgainst addObject:self.caa];
    [testAgainst addObject:self.cab];
    [testAgainst addObject:self.cfz];
    [testAgainst addObject:self.egg];
    [testAgainst addObject:self.cab8];
    [testAgainst addObject:self.cabs];
    [testAgainst addObject:self.efgh];
    [testAgainst addObject:self.ad123];
    [testAgainst addObject:self.fghij];
    
    NSArray<PMConversation *> *testing = [self.testTree retreiveSubTree:@""];
    for (int i = 0; i < testAgainst.count; i++){
        XCTAssertEqualObjects(testing[i], testAgainst[i]);
    }
}

@end
