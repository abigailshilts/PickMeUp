//
//  ReuseFunctions.m
//  PickMeUp
//
//  Created by Abigail Shilts on 8/2/22.
//
#import <CoreLocation/CoreLocation.h>
#import "Parse/Parse.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "Post.h"
#import "PMDirectMessage.h"
#import "PMReuseFunctions.h"
#import "StringsList.h"

@implementation PMReuseFunctions

static const NSString *const kLiveQueryURL = @"wss://pickmeup2.b4a.io";
static const NSString *const kErrCreateDMString = @"Creating Message Error";
static const NSString *const kErrCreateDMMessage =
    @"There appears to be an error with saving this message, check your internet and try again";
static const NSString *const kErrPostingImgString = @"Error Posting Photo";
static const NSString *const kErrPostingImgMessage =
    @"There appears to be an error savin this post, check your internet and try again";

+(PFLiveQueryClient *)createLiveQueryObj {
    NSString *path = [[NSBundle mainBundle] pathForResource:kKeysString ofType:kPlistTitle];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *key = [dict objectForKey:kAppIDString];
    NSString *secret = [dict objectForKey:kClientKey];

    PFLiveQueryClient *toReturn =
        [[PFLiveQueryClient alloc] initWithServer:kLiveQueryURL applicationId:key clientKey:secret];
    return toReturn;
}

/**
 *  Creates an alert to show user
 *  @param title of the alert
 *  @param message of the alert
 *  @param vc to display alert in
 */
+(void)presentPopUp:(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kOkString style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:okAction];
    [vc presentViewController:alert animated:YES completion:^{}];
}

/**
 * Sends a post request to the database for any newly sent DM
 * @param content the message in the DM
 * @param searchById the convo id to associate the DM with
 */
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

/**
 * Resizes an image selected by user to fit in parse database
 * @param image to be resized
 * @param size to change image to
 * @return the resized image
 */
+(UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 * Retrieves the Geolocation and coordinates of a given street address, adds them to a post object and does a post request on the object saving it to the database
 *  @param toSave the post that is going to be saved to the database
 *  @param geocoder the geocoder object used for translating street address
 *  @param address the street address to be translated
 */
+(void)savePostWithLocation:(Post *)toSave geoCoder:(CLGeocoder *)geocoder address:(NSString *)address
        withImage:(UIImage * _Nullable)image {
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSString *title = [NSString stringWithFormat:kStrInput, error];
            [PMReuseFunctions presentPopUp:title message:kEmpt viewController:self];
            return;
        }
        // A location was generated
        if (placemarks && [placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0]; // Our placemark
            
            // creates geoPoint (for parse) from CLLocation
            PFGeoPoint *curLoc = [PFGeoPoint geoPointWithLocation:placemark.location];
            toSave.curLoc = curLoc;
            toSave.latitude = placemark.location.coordinate.latitude;
            toSave.longitude = placemark.location.coordinate.longitude;
            
            [toSave postUserImage:image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil){
                    [PMReuseFunctions presentPopUp:kErrPostingImgString message:kErrPostingImgMessage viewController:self];
                } else {
                    NSLog(kPostedSuccessString);
                }
            }];
        }
    }];
}

@end
