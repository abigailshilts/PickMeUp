//
//  PMTree.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/21/22.
//
#import <Foundation/Foundation.h>
#import "PMNode.h"

#ifndef PMTree_h
#define PMTree_h
@interface PMTree: NSObject
@property (nonatomic, strong) PMNode *rootNode;
-(PMTree *)init;
// Ideally traverse would be private but for now for testing leaving as public
-(PMNode *)traverseToNode:(NSString *)endString withstartNode:(PMNode *)startNode;
@end
#endif /* PMTree_h */
