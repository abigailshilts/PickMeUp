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
@class PMPost;

NS_ASSUME_NONNULL_BEGIN

@interface PMReuseFunctions : NSObject
+(PFLiveQueryClient *)createLiveQueryObj;
+(void)presentPopUp:(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc;
+(void)saveDM:(NSString *)content searchById:(NSString *)searchById;
+(UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+(void)savePostWithLocation:(CLGeocoder *)geocoder address:(NSString *)address bio:(NSString *)bio sport:(NSString *)sport intensity:(NSString *)intensity groupWhen:(NSString *)groupWhen isEvent:(NSString *)isEvent withImage:(UIImage * _Nullable)image;
@end

NS_ASSUME_NONNULL_END
