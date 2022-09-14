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
@import FirebaseCore;
@import FirebaseFirestore;
@import FirebaseAuth;


@interface PMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *insertedEmail;
@property (weak, nonatomic) IBOutlet UITextField *insertedPassword;
@property (strong, nonatomic) JHUD *hudView;
@end

@implementation PMLoginViewController

static const NSString *const kLoginToSearchSegue  = @"loginToSearch";
static const NSString *const kLogginginNeedsAllString = @"Logging in requires all fields to be filled";
static const NSString *const kFailedLogInString = @"User log in failed: %@";
static const NSString *const kUserLogInSuccesString = @"User logged in successfully";
static const NSString *const kGoToSignUpSegue = @"goToSignUp";
static const NSString *const kHudMessageString = @"Logging user in";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSignUp:(id)sender {
    [[FIRAuth auth] createUserWithEmail:self.insertedEmail.text
                               password:self.insertedPassword.text
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
//TODO: add error handling
    }];
    [self performSegueWithIdentifier:kGoToSignUpSegue sender:nil];
}


- (IBAction)didTapLogin:(id)sender {
    [[FIRAuth auth] signInWithEmail:self.insertedEmail.text
                           password:self.insertedPassword.text
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
        [self performSegueWithIdentifier:kLoginToSearchSegue sender:nil];
    }];
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];

    self.hudView.messageLabel.text = kHudMessageString;
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
}


@end
