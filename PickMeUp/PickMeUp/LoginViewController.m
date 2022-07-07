//
//  LoginViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "LoginViewController.h"
#import "StringsList.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *insertedUsername;
@property (weak, nonatomic) IBOutlet UITextField *insertedPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}



- (void)loginUser {
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
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
        }
    }];
}

- (IBAction)didTapSignUp:(id)sender {
    [self performSegueWithIdentifier:goToSignUp sender:nil];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
    [self performSegueWithIdentifier:loginToSearch sender:nil];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
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
