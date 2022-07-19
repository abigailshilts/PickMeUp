//
//  LoginViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "PMLoginViewController.h"
#import "Parse/Parse.h"
#import "StringsList.h"


@interface PMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *insertedUsername;
@property (weak, nonatomic) IBOutlet UITextField *insertedPassword;

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



- (void)loginUser {
    // Pop up alert to ensure user enters all fields

    if ([self.insertedUsername.text isEqual:kEmpt] || [self.insertedPassword.text isEqual:kEmpt]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kMissingFieldsString message:kLogginginNeedsAllString preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkString style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
        return;
    }
    
    NSString *username = self.insertedUsername.text;
    NSString *password = self.insertedPassword.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            // TODO: Add alert w/ message about user doesn't exist
            NSLog(kFailedLogInString, error.localizedDescription);
        } else {
            NSLog(kUserLogInSuccesString);
            [self performSegueWithIdentifier:kLoginToSearchSegue sender:nil];
        }
    }];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:kGoToSignUpSegue sender:nil];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}


@end
