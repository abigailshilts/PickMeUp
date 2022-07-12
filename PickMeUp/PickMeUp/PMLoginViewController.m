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

- (void)viewDidLoad {
    [super viewDidLoad];

}



- (void)loginUser {
    // Pop up alert to ensure user enters all fields
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:missingFields message:logginginNeedsAll preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    if ([self.insertedUsername.text isEqual:empt] || [self.insertedPassword.text isEqual:empt]){
        [self presentViewController:alert animated:YES completion:^{}];
        return;
    }
    
    NSString *username = self.insertedUsername.text;
    NSString *password = self.insertedPassword.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            // TODO: Add alert w/ message about user doesn't exist
            NSLog(failedLogIn, error.localizedDescription);
        } else {
            NSLog(userLogInSuccess);
            [self performSegueWithIdentifier:loginToSearch sender:nil];
        }
    }];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:goToSignUp sender:nil];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}


@end
