//
//  LoginViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "JHUD.h"
#import "Parse/Parse.h"
#import "PMLoginViewController.h"
#import "PMReuseFunctions.h"
#import "StringsList.h"


@interface PMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *insertedUsername;
@property (weak, nonatomic) IBOutlet UITextField *insertedPassword;
@property (strong, nonatomic) JHUD *hudView;
@end

@implementation PMLoginViewController

static const NSString *const kLoginToSearchSegue  = @"loginToSearch";
static const NSString *const kLogginginNeedsAllString = @"Logging in requires all fields to be filled";
static const NSString *const kFailedLogInString = @"User log in failed: %@";
static const NSString *const kUserLogInSuccesString = @"User logged in successfully";
static const NSString *const kGoToSignUpSegue = @"goToSignUp";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)_loginUser {
    // Pop up alert to ensure user enters all fields
    if ([self.insertedUsername.text isEqual:kEmpt] || [self.insertedPassword.text isEqual:kEmpt]){
        [PMReuseFunctions presentPopUp:kMissingFieldsString message:kLogginginNeedsAllString viewController:self];
        return;
    }
    
    NSString *username = self.insertedUsername.text;
    NSString *password = self.insertedPassword.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(kFailedLogInString, error.localizedDescription);
        } else {
            NSLog(kUserLogInSuccesString);
            [self performSegueWithIdentifier:kLoginToSearchSegue sender:nil];
        }
        [self.hudView hide];
    }];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:kGoToSignUpSegue sender:nil];
}

- (IBAction)didTapLogin:(id)sender {
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];

    self.hudView.messageLabel.text = @"Logging user in";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    [self _loginUser];
//    [self.hudView hide];
}


@end
