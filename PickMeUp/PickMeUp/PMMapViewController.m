//
//  MapViewController.m
//  PickMeUp
//
//  Created by Abigail Shilts on 7/13/22.
//

#import "PMMapViewController.h"
#import "PMDetailsViewController.h"
#import "StringsList.h"
@import GoogleMaps;

@interface PMMapViewController () <GMSMapViewDelegate>
@property (nonatomic, strong) Post *tappedPost;
@end

@implementation PMMapViewController {
    GMSMapView *_mapView;
}

static const NSString *const kShowMarkerSegue = @"showMarkerDetail";

- (void)loadView {
    [super loadView];
    // creates mapview
    float latitude = self.pointToSet.coordinate.latitude;
    float longitude = self.pointToSet.coordinate.longitude;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:12];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = _mapView;
    _mapView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //creates markers
    NSMutableArray <GMSMarker *> *markers;
    for (Post *post in self.arrayOfPosts){
        CLLocationCoordinate2D markerCoor = CLLocationCoordinate2DMake(post.latitude, post.longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:markerCoor];
        marker.map = _mapView;
        marker.userData = post;
        [markers addObject:marker];
    }
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    //segues to details view when marker is selected
    [_mapView animateToLocation:marker.position];
    self.tappedPost = marker.userData;
    [self performSegueWithIdentifier:kShowMarkerSegue sender:nil];
    return NO;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationVC = [segue destinationViewController];
    PMDetailsViewController *displayVC = navigationVC.topViewController;
    Post *post = self.tappedPost;
    displayVC.post = post;
}


@end
