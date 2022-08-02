//
//  PMCachingFunctions.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/26/22.
//
#import <Foundation/Foundation.h>
#import "PMConversation.h"
#import "PMDirectMessage.h"

#ifndef PMCachingFunctions_h
#define PMCachingFunctions_h

@interface PMCachingFunctions : NSObject
+(void)updateConversationCache:(NSArray<PMConversation *> *)convos;
+(void)updateDMCache:(NSArray<PMDirectMessage *> *)DMs conversation:(NSString *)idToSave;
+(NSArray<PMDirectMessage *> *)translateDMs:(NSString *)idToSearch;
+(NSArray<PMConversation *> *)retreiveConversationCache;
@end

#endif
