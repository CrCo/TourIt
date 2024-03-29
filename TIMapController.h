//
//  TIMapController.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIPointOfInterest.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@class TIMapController;

@protocol TIMapControllerDelegate <NSObject>

- (void) mapController: (TIMapController *) controller didSomething: (id) object;
- (void) mapControllerWantsBackPlease: (TIMapController *) controller;

@end

@interface TIMapController : UIViewController <MKMapViewDelegate> {

}

@property (nonatomic, strong) PFObject *selectedPOI;
@property (nonatomic, weak) id<TIMapControllerDelegate> delegate;
- (IBAction)cancelMap:(id)sender;

@end
