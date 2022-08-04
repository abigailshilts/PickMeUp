//
//  ReuseFunctions.h
//  PickMeUp
//
//  Created by Abigail Shilts on 8/2/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMReuseFunctions : NSObject
+(PFLiveQueryClient *)createLiveQueryObj;
+(void)presentPopUp:(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc;
+(void)saveDM:(NSString *)content searchById:(NSString *)searchById;
+(UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+(void)savePostWithLocation:(Post *)toSave geoCoder:(CLGeocoder *)geocoder address:(NSString *)address withImage:(UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
