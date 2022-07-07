//
//  Post.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//

#import "Post.h"
#import "Parse/Parse.h"
#import "StringsList.h"

@implementation Post
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic bio;
@dynamic image;
@dynamic intensity;
@dynamic sport;
@dynamic groupWhere;
@dynamic groupWhen;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

//+ (void) postUserImage: ( UIImage * _Nullable )image withBio:
//    ( NSString * _Nullable )bio withSport:
//( NSString * _Nullable )sport withIntensity:
//( NSString * _Nullable )intensity withgroupWhere:
//( NSString * _Nullable )groupWhere withGroupWhen:
//( NSString * _Nullable )groupWhen withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//
//    Post *newPost = [Post new];
//    newPost.image = [self getPFFileFromImage:image];
//    newPost.author = [PFUser currentUser];
//    newPost.bio = bio;
//    newPost.groupWhere = groupWhere;
//    newPost.groupWhen = groupWhen;
//    newPost.intensity = intensity;
//    newPost.sport = sport;
//
//    [newPost saveInBackgroundWithBlock: completion];
//}
//
//+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
//
//    // check if image is not nil
//    if (!image) {
//        return nil;
//    }
//
//    NSData *imageData = UIImagePNGRepresentation(image);
//    // get image data and check if that is not nil
//    if (!imageData) {
//        return nil;
//    }
//
//    return [PFFileObject fileObjectWithName:ipng data:imageData];
//}



//- (nonnull NSString *)parseClassName {
//    return @"Post";
//}

- (void) postUserImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    self.image = [self getPFFileFromImage:image];
    self.author = [PFUser currentUser];
    [self saveInBackgroundWithBlock: completion];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {

    // check if image is not nil
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }

    return [PFFileObject fileObjectWithName:ipng data:imageData];
}

@end
