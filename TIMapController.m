//
//  TIMapController.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TIMapController.h"
#import "TIPoiPin.h"

@interface TIMapController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) TIPoiPin *currentPin;

@end

@implementation TIMapController

@synthesize map;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSLog(@"Map did load, %@", self.selectedPOI.description);
    
}

- (void) setSelectedPOI:(PFObject *)selectedPOI {
    [self.map removeAnnotation:self.currentPin];
    _selectedPOI = selectedPOI;

    CLLocationCoordinate2D location;
    location.latitude = [[self.selectedPOI objectForKey:@"location"] latitude];
    location.longitude = [[self.selectedPOI objectForKey:@"location"] longitude];
    
    NSString *title = [self.selectedPOI objectForKey:@"title"];
    self.currentPin = [[TIPoiPin alloc] initWithCoordinates:location placeName:title description:@""];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocation *myCurrentLocation = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:self.currentPin.coordinate.latitude longitude:self.currentPin.coordinate.longitude];
    
    CLLocationDistance distanceBetweenPoints = [myCurrentLocation distanceFromLocation:annotationLocation];
//    NSLog(@"Distance %f", distanceBetweenPoints);
    [map addAnnotation:self.currentPin];
    
    MKCoordinateRegion mapRegion;
    
    if (distanceBetweenPoints > 1200) {
        MKCoordinateRegion annotationRegion;
        annotationRegion.center.latitude = userLocation.location.coordinate.latitude;
        annotationRegion.center.longitude = userLocation.location.coordinate.longitude;
        annotationRegion.span.latitudeDelta = 2 * ABS(self.currentPin.coordinate.latitude - userLocation.location.coordinate.latitude);
        annotationRegion.span.longitudeDelta = 2 * ABS(self.currentPin.coordinate.longitude - userLocation.location.coordinate.longitude);
        mapRegion = [map regionThatFits:annotationRegion];
        [map setRegion:mapRegion animated:NO];
    } else {
        mapRegion = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1200, 1200);
        [mapView setRegion: mapRegion animated:NO];
    }

}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    id myAnnotation = [mapView.annotations objectAtIndex:0];
    [mapView selectAnnotation:myAnnotation animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelMap:(id)sender {
    [self.delegate mapControllerWantsBackPlease:self];
}
@end
