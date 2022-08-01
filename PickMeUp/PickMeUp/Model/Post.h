//
//  Post.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Parse/Parse.h"
@import GoogleMaps;

NS_ASSUME_NONNULL_BEGIN

static const NSString *const kPostClassName = @"Post";
static const NSString *const kAuthorKey = @"author";
static const NSString *const kSportKey = @"sport";
static const NSString *const kIntensityKey = @"intensity";
static const NSString *const kCurLocKey = @"curLoc";

@interface Post : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *intensity;
@property (nonatomic, strong) NSString *groupWhere;
@property (nonatomic, strong) NSString *groupWhen;
@property (nonatomic, strong) NSString *isEvent;
@property float latitude;
@property float longitude;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) PFUser *author;
@property (strong, nonatomic) PFGeoPoint *curLoc;
@property CLLocationDistance distToCurUser;
//@property (nonatomic, strong) NSArray *convoId;
//@property (nonatomic, strong) NSArray<PFUser *> *convoRecipients;
- (void) postUserImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
