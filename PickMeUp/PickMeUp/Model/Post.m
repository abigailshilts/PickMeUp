//
//  Post.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/6/22.
//
#import "Parse/Parse.h"
#import "Post.h"
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
@dynamic curLoc;
@dynamic latitude;
@dynamic longitude;
@dynamic isEvent;

+ (nonnull NSString *)parseClassName {
    return kPostClassName;
}

- (void)postUserImage: (UIImage * _Nullable)image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    self.image = [self _getPFFileFromImage:image];
    self.author = [PFUser currentUser];
    [self saveInBackgroundWithBlock: completion];
}

- (PFFileObject *)_getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }

    return [PFFileObject fileObjectWithName:kIpngString data:imageData];
}

@end
