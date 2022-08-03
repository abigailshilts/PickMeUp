//
//  ReuseFunctions.m
//  PickMeUp
//
//  Created by Abigail Shilts on 8/2/22.
//
#import "Parse/Parse.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "PMDirectMessage.h"
#import "PMReuseFunctions.h"
#import "StringsList.h"

@implementation PMReuseFunctions

static const NSString *const kLiveQueryURL = @"wss://pickmeup2.b4a.io";
static const NSString *const kErrCreateDMString = @"Creating Message Error";
static const NSString *const kErrCreateDMMessage =
    @"There appears to be an error with saving this message, check your internet and try again";

+(PFLiveQueryClient *)createLiveQueryObj {
    NSString *path = [[NSBundle mainBundle] pathForResource:kKeysString ofType:kPlistTitle];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [dict objectForKey:kAppIDString];
    NSString *secret = [dict objectForKey:kClientKey];

    PFLiveQueryClient *toReturn =
        [[PFLiveQueryClient alloc] initWithServer:kLiveQueryURL applicationId:key clientKey:secret];
    return toReturn;
}

+(void)presentPopUp:(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkString style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [vc presentViewController:alert animated:YES completion:^{}];
}

+(void)saveDM:(NSString *)content searchById:(NSString *)searchById {
    // posts DM to database and refreshes the table
    PMDirectMessage *newDM = [PMDirectMessage new];
    newDM.content = content;
    newDM.convoId = searchById;
    newDM.sender = PFUser.currentUser;
    [newDM postDM:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil){
            [PMReuseFunctions presentPopUp:kErrCreateDMString message:kErrCreateDMMessage viewController:self];
        }
    }];
}

@end
