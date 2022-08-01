//
//  PMEvent.h
//  PickMeUp
//
//  Created by Abigail Shilts on 8/1/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PMEvent : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *eventWhere;
@property (nonatomic, strong) NSString *eventWhen;
@property (strong, nonatomic) PFGeoPoint *curLoc;
@property (nonatomic, strong) PFFileObject *image;
- (void)postUserEvent: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
