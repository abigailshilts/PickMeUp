//
//  PMCachingFunctions.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/26/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "PMCachingFunctions.h"
#import "PMConversation.h"
#import "PMDirectMessage.h"
#import "StringsList.h"

@interface PMCachingFunctions ()
@end

@implementation PMCachingFunctions

static const NSString *const kConversationCacheFile = @"ConversationCache.plist";
static const NSString *const kConversationCache = @"ConversationCache";
static const NSString *const kDMCacheFile = @"DMCache.plist";
static const NSString *const kDMCache = @"DMCache";

+(void)updateConversationCache:(NSArray<PMConversation *> *)convos {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kConversationCacheFile];

    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:kConversationCache ofType:kPlistTitle];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
        if (error != nil){
            NSLog(@"%@", error);
            return;
        }
    }
    
    NSMutableArray<NSDictionary *> *conversations = [NSMutableArray new];
    for (PMConversation *convo in convos) {
        NSDictionary *toAdd = @{kObjectIDKey:convo.objectId,
                                kSenderKey:[convo.sender fetchIfNeeded].username,
                                kReceiverKey:[convo.receiver fetchIfNeeded].username,
        };
        [conversations addObject:toAdd];
    }

    [conversations writeToFile:plistPath atomically:YES];
}

+(void)updateDMCache:(NSArray<PMDirectMessage *> *)DMs conversation:(PMConversation *)convo {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kDMCacheFile];

    NSMutableArray<NSDictionary *> *directMessages = [NSMutableArray new];
    for (PMDirectMessage *DM in DMs) {
        NSDictionary *toAdd = @{kObjectIDKey:DM.objectId,
                                kSenderKey:[DM.sender fetchIfNeeded].username,
                                @"content":DM.content,
                                @"convoId":DM.convoId
        };
        [directMessages addObject:toAdd];
    }
    
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:kDMCache ofType:kPlistTitle];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
        NSDictionary *forCache = @{convo.objectId:directMessages,
        };
        [forCache writeToFile:plistPath atomically:YES];
    } else {
        NSMutableDictionary *currentCache = [self _retreiveDMCache];
        currentCache[convo.objectId] = directMessages;
        [currentCache writeToFile:plistPath atomically:YES];
    }

}

+(NSMutableDictionary *)_retreiveDMCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kDMCacheFile];
    if ([fileManager fileExistsAtPath:plistPath] == YES) {
        NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
        return savedValue;
    } else {
        return nil;
    }
}

+(NSArray<PMDirectMessage *> *)translateDMs:(PMConversation *)convo {
    NSMutableDictionary *totalCache = [self _retreiveDMCache];
    NSArray<PMDirectMessage *> *messages = totalCache[convo.objectId];
    NSMutableArray<PMDirectMessage *> *toReturn = [NSMutableArray new];
    for (NSDictionary *dict in messages) {
        PMDirectMessage *toAdd = [PMDirectMessage new];
        toAdd.objectId = dict[kObjectIDKey];
        PFUser *sender = [PFUser new];
        sender.username = dict[kSenderKey];
        toAdd.sender = sender;
        toAdd.content = dict[@"content"];
        toAdd.convoId = dict[@"convoId"];
        [toReturn addObject:toAdd];
    }
    return toReturn;
}

+(NSArray<PMConversation *> *)retreiveConversationCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kConversationCacheFile];
    NSMutableArray<PMConversation *> *conversations = [NSMutableArray new];
    if ([fileManager fileExistsAtPath:plistPath] == YES) {
        NSMutableArray<NSDictionary *> *savedValue = [[NSMutableArray alloc] initWithContentsOfFile: plistPath];
        for (NSDictionary *dict in savedValue){
            PMConversation *toAdd = [PMConversation new];
            toAdd.objectId = dict[kObjectIDKey];
            PFUser *tempSender = [PFUser new];
            tempSender.username = dict[kSenderKey];
            toAdd.sender = tempSender;
            PFUser *tempReceiver = [PFUser new];
            tempReceiver.username = dict[kReceiverKey];
            toAdd.receiver = tempReceiver;
            [conversations addObject:toAdd];
        }
        return conversations;
    } else {
        return nil;
    }
}

@end
