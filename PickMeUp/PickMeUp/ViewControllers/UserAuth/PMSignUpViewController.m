//
//  SignUpViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/5/22.
//

#import "Parse/Parse.h"
#import "PickMeUp-Swift.h"
#import "PMReuseFunctions.h"
#import "PMSignUpViewController.h"
#import "StringsList.h"
@import FirebaseCore;
@import FirebaseFirestore;
@import FirebaseAuth;
@import FirebaseStorage;

@interface PMSignUpViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *insertedUsername;
@property (weak, nonatomic) IBOutlet UIImageView *profPhoto;

@end

@implementation PMSignUpViewController

static const NSString *const kSigningupRequiresAllString = @"Signing up requires all fields to be filled";
static const NSString *const kSignUpToSearchSegue = @"signUpToSearch";
static const NSString *const kUserRegSuccessString = @"User registered successfully";
static const NSString *const kRegisteringErrString = @"Error registering user";
static const NSString *const kRegisteringErrMessage = @"User likely already exists";
static const int kImgSize = 580;

- (void)viewDidLoad {
    [super viewDidLoad];
    // gesture so tapping img photo pulls up library
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.profPhoto addGestureRecognizer:tapRecognizer];
    
    self.insertedUsername.delegate = self;
}

- (BOOL)_textFieldShouldReturn:(UITextField *)textField {
   [textField resignFirstResponder];
   return true;
}

// pulls up library when img is tapped
- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    originalImage = [PMReuseFunctions resizeImage:originalImage withSize:CGSizeMake(kImgSize,kImgSize)];
    
    // changes img on view controller to one seleted
    [self.profPhoto setImage:originalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapGo:(id)sender {
    [PMPost saveImageWithImagee:self.profPhoto.image userID:[FIRAuth auth].currentUser.uid completion:^(NSURL *dURL) {
        FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
        changeRequest.displayName = self.insertedUsername.text;
        changeRequest.photoURL = dURL;
        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error);
            }
        }];
    }];
    [self performSegueWithIdentifier:kSignUpToSearchSegue sender:nil];
}


@end
