//
//  PMEvent.m
//  PickMeUp
//
//  Created by Abigail Shilts on 8/1/22.
//

#import "PMEvent.h"
#import "StringsList.h"

@implementation PMEvent
@dynamic bio;
@dynamic eventWhere;
@dynamic eventWhen;
@dynamic curLoc;
@dynamic image;

+ (nonnull NSString *)parseClassName {
    return @"PMEvent";
}

- (void)postUserEvent: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    self.image = [self _getPFFileFromImage:image];
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
