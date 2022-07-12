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
@dynamic curLoc;

+ (nonnull NSString *)parseClassName {
    return classPost;
}

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
