//
//  TICameraControllerViewController.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TICameraControllerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
- (IBAction)AcceptImage:(id)sender;
- (IBAction)RetakeImage:(id)sender;

@end
