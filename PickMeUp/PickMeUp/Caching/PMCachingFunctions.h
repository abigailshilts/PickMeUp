//
//  PMCachingFunctions.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/26/22.
//
#import <Foundation/Foundation.h>
#import "PMConversation.h"

#ifndef PMCachingFunctions_h
#define PMCachingFunctions_h

@interface PMCachingFunctions : NSObject
+(void)updateCache:(NSArray<PMConversation *> *)convos;
+(NSArray<PMConversation *> *)retreiveCache;
@end

#endif
