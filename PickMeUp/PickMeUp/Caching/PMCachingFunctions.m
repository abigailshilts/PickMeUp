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
static const NSString *const kDotPlist = @".plist";
static const NSString *const kContentKey = @"content";
static const NSString *const kConvoIdKey = @"convoId";

+(void)updateConversationCache:(NSArray<PMConversation *> *)convos {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kConversationCache];
    plistPath = [plistPath stringByAppendingString:PFUser.currentUser.objectId];
    plistPath = [plistPath stringByAppendingString:kDotPlist];

    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:kConversationCache ofType:kPlistTitle];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
        if (error != nil){
            NSLog(@"Couldn't copy conversation plist: %@", error);
            return;
        }
    }
    
    NSMutableArray<NSDictionary *> *conversations = [NSMutableArray new];
    for (PMConversation *convo in convos) {
        [convo.sender fetchIfNeeded];
        [convo.receiver fetchIfNeeded];
        NSDictionary *toAdd = @{kObjectIDKey:convo.objectId,
                                kSenderKey:convo.sender.username,
                                kReceiverKey:convo.receiver.username,
        };
        [conversations addObject:toAdd];
    }

    [conversations writeToFile:plistPath atomically:YES];
}

+(void)updateDMCache:(NSArray<PMDirectMessage *> *)DMs conversation:(NSString *)idToSave {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kDMCache];
    plistPath = [plistPath stringByAppendingString:PFUser.currentUser.objectId];
    plistPath = [plistPath stringByAppendingString:kDotPlist];

    NSMutableArray<NSDictionary *> *directMessages = [NSMutableArray new];
    for (PMDirectMessage *DM in DMs) {
        NSDictionary *toAdd = @{kObjectIDKey:DM.objectId,
                                kSenderKey:[DM.sender fetchIfNeeded].username,
                                kContentKey:DM.content,
                                kConvoIdKey:DM.convoId
        };
        [directMessages addObject:toAdd];
    }
    
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:kDMCache ofType:kPlistTitle];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
        NSDictionary *forCache = @{idToSave:directMessages};
        [forCache writeToFile:plistPath atomically:YES];
        NSMutableDictionary *savedValue = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
    } else {
        NSMutableDictionary *currentCache = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
        currentCache[idToSave] = directMessages;
        [currentCache writeToFile:plistPath atomically:YES];
    }

}

+(NSArray<PMDirectMessage *> *)translateDMs:(NSString *)idToSearch {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kDMCache];
    plistPath = [plistPath stringByAppendingString:PFUser.currentUser.objectId];
    plistPath = [plistPath stringByAppendingString:kDotPlist];

    if ([fileManager fileExistsAtPath:plistPath] == YES) {
        NSMutableDictionary *totalCache = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
        NSArray<PMDirectMessage *> *messages = totalCache[idToSearch];
        NSMutableArray<PMDirectMessage *> *toReturn = [NSMutableArray new];
        for (NSDictionary *dict in messages) {
            PMDirectMessage *toAdd = [PMDirectMessage new];
            toAdd.objectId = dict[kObjectIDKey];
            PFUser *sender = [PFUser new];
            sender.username = dict[kSenderKey];
            toAdd.sender = sender;
            toAdd.content = dict[kContentKey];
            toAdd.convoId = dict[kConvoIdKey];
            [toReturn addObject:toAdd];
        }
        return toReturn;
    }
    return nil;
}

+(NSArray<PMConversation *> *)retreiveConversationCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:kConversationCache];
    plistPath = [plistPath stringByAppendingString:PFUser.currentUser.objectId];
    plistPath = [plistPath stringByAppendingString:kDotPlist];
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
