//
//  Post.h
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *intensity;
@property (nonatomic, strong) NSString *groupWhere;
@property (nonatomic, strong) NSString *groupWhen;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) PFUser *author;

- (void) postUserImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion;
//@property (nonatomic, strong) PFUser *author;
//
//+ (void) postUserImage: ( UIImage * _Nullable )image withBio:
//    ( NSString * _Nullable )bio withSport:
//( NSString * _Nullable )sport withIntensity:
//( NSString * _Nullable )intensity withgroupWhere:
//( NSString * _Nullable )groupWhere withGroupWhen:
//( NSString * _Nullable )groupWhen withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
