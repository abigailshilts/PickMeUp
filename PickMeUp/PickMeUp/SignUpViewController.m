//
//  SignUpViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "SignUpViewController.h"
#import "StringsList.h"
#import "Parse/Parse.h"


@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *insertedEmail;
@property (weak, nonatomic) IBOutlet UITextField *insertedUsername;
@property (weak, nonatomic) IBOutlet UITextField *insertedPassword;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)registerUser {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:missingFields message:signingupRequiresAll preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    if ([self.insertedUsername.text isEqual:empt] || [self.insertedPassword.text isEqual:empt] || [self.insertedEmail.text isEqual:empt]){
        [self presentViewController:alert animated:YES completion:^{}];
        return;
    }
    
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.insertedUsername.text;
    newUser.email = self.insertedEmail.text;
    newUser.password = self.insertedPassword.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
        }
    }];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
    [self performSegueWithIdentifier:signUpToSearch sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
