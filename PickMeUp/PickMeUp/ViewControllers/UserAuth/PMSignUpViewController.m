//
//  SignUpViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "Parse/Parse.h"
#import "PMReuseFunctions.h"
#import "PMSignUpViewController.h"
#import "StringsList.h"

@interface PMSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *insertedEmail;
@property (weak, nonatomic) IBOutlet UITextField *insertedUsername;
@property (weak, nonatomic) IBOutlet UITextField *insertedPassword;

@end

@implementation PMSignUpViewController

static const NSString *const kSigningupRequiresAllString = @"Signing up requires all fields to be filled";
static const NSString *const kSignUpToSearchSegue = @"signUpToSearch";
static const NSString *const kUserRegSuccessString = @"User registered successfully";
static const NSString *const kRegisteringErrString = @"Error registering user";
static const NSString *const kRegisteringErrMessage = @"User likely already exists";

- (void)_registerUser {
    // Pop up alert to ensure user enters all fields
    if ([self.insertedUsername.text isEqual:kEmpt] || [self.insertedPassword.text isEqual:kEmpt]
        || [self.insertedEmail.text isEqual:kEmpt]){
        [PMReuseFunctions presentPopUp:kMissingFieldsString message:kSigningupRequiresAllString viewController:self];
        return;
    }
    PFUser *newUser = [PFUser user];
    newUser.username = self.insertedUsername.text;
    newUser.email = self.insertedEmail.text;
    newUser.password = self.insertedPassword.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            [PMReuseFunctions presentPopUp:kRegisteringErrString message:kRegisteringErrMessage viewController:self];
        } else {
            NSLog(kUserRegSuccessString);
            [self performSegueWithIdentifier:kSignUpToSearchSegue sender:nil];
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSignUp:(id)sender {
    [self _registerUser];
}

@end
