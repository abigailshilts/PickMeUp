//
//  AppDelegate.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "AppDelegate.h"
#import "StringsList.h"
#import "Parse/Parse.h"
@import GoogleMaps;
@import FirebaseCore;
@import FirebaseFirestore;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:kKeysString ofType:kPlistTitle];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey:kAppIDString];
    NSString *secret = [dict objectForKey:kClientKey];
    NSString *maps = [dict objectForKey:@"mapsKey"];
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = key;
        configuration.clientKey = secret;
        configuration.server = kServerLink;
    }];
    [GMSServices provideAPIKey:maps];
    [Parse initializeWithConfiguration:config];
    [FIRApp configure];
    FIRFirestore *db = [FIRFirestore firestore];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
