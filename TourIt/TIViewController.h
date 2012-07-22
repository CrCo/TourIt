//
//  TIViewController.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TICameraControllerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TIMapController.h"

@interface TIViewController : UIViewController <TICameraControllerViewControllerDelegate, CLLocationManagerDelegate, TIMapControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end
