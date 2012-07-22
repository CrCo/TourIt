//
//  TICameraControllerViewController.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIPointOfInterest.h"

@class TICameraControllerViewController;

@protocol TICameraControllerViewControllerDelegate <NSObject>

- (void)cameraDidCancel: (TICameraControllerViewController *) controller;
- (void)camera: (TICameraControllerViewController *) controller didCreatePOI: (TIPointOfInterest *) point;

@end

@interface TICameraControllerViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<TICameraControllerViewControllerDelegate> delegate;
@property (nonatomic, strong) TIPointOfInterest *poi;
@property (strong, nonatomic) UIImage *image;

- (void) loadGroups;

@end
