//
//  TICameraControllerViewController.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TICameraControllerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *ImageView;

- (IBAction)retakeImage:(id)sender;
- (IBAction)acceptImage:(id)sender;

@end
