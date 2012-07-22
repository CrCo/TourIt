//
//  TIMapController.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIPointOfInterest.h"

@class TIMapController;

@protocol TIMapControllerDelegate <NSObject>

- (void) mapController: (TIMapController *) controller didSomething: (id) object;

@end

@interface TIMapController : UIViewController

@property (nonatomic, strong) TIPointOfInterest *selectedPOI    ;
@property (nonatomic, weak) id<TIMapControllerDelegate> delegate;

@end
