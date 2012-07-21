//
//  TICameraControllerViewController.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TICameraControllerViewController.h"

@interface TICameraControllerViewController ()

- (IBAction)retakeImage:(id)sender;

- (IBAction)textComplete:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;

@end

@implementation TICameraControllerViewController {
    bool cameraHasPopped;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleField becomeFirstResponder];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((TICameraControllerViewController *)segue.destinationViewController).delegate = self.delegate;
    TIPointOfInterest *poi = [[TIPointOfInterest alloc] init];
    poi.image = self.ImageView.image;
    ((TICameraControllerViewController *)segue.destinationViewController).poi = poi;
}
- (IBAction)textComplete:(id)sender {
    self.poi.title = self.titleField.text;
    self.poi.details = self.detailsField.text;
    [self.delegate camera:self didCreatePOI:self.poi];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [self textComplete:textView];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    
    return YES;

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
