//
//  TICameraControllerViewController.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TICameraControllerViewController.h"

@interface TICameraControllerViewController ()

@end

@implementation TICameraControllerViewController {
    bool cameraHasPopped;
}

@synthesize ImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    cameraHasPopped = NO;
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    if (!cameraHasPopped) {
       [self popCameraUI];
        cameraHasPopped = YES;
    }
    
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:NULL];
    
    return YES;
}

-(void) popCameraUI {
    
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retakeImage:(id)sender {
    [self popCameraUI];
}

- (IBAction)acceptImage:(id)sender {

}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];

}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissModalViewControllerAnimated:YES];  
    
    UIImage *capturedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ImageView.image = capturedImage;
}

@end
