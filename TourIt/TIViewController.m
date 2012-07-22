//
//  TIViewController.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TIViewController.h"
#import "TIMapController.h"
#import <Parse/Parse.h>

@interface TIViewController ()

@property (nonatomic, strong) NSArray *populars;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic) CLLocationCoordinate2D bestGuess;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *cameraUI;
- (IBAction)handlePan:(id)sender;
- (IBAction)openCamera:(id)sender;

@end

@implementation TIViewController
@synthesize imageView = _imageView;
@synthesize tableView = _tableView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSLog(@"Location services are %@", [CLLocationManager locationServicesEnabled] ? @"on" : @"Ball-licking piece of shit");
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        [self.manager startUpdatingLocation];
        
        if ([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeCamera])
        {
            self.cameraUI = [[UIImagePickerController alloc] init];
            self.cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            // Displays a control that allows the user to choose picture or
            // movie capture, if both are available:
            self.cameraUI.allowsEditing = NO;
            self.cameraUI.delegate = self;
        }
        else
        {
            self.cameraUI = [[UIImagePickerController alloc] init];
            self.cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            self.cameraUI.delegate = self;
        }
    }
    return self;
}

- (void) setPopularPOIs: (NSArray *) pois
{
    self.populars = pois;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:@"PointOfInterest"];
    query.limit = 100;
    [query findObjectsInBackgroundWithTarget:self selector:@selector(setPopularPOIs:)];
    
    self.imageView.image = [UIImage animatedImageWithImages:@[[UIImage imageNamed:@"arrow1"], [UIImage imageNamed:@"arrow2"]] duration:2.0];

    self.cameraUI.view.transform = CGAffineTransformMakeTranslation(0, -self.cameraUI.view.frame.size.height);
    [self.view addSubview:self.cameraUI.view];
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIView animateWithDuration:1.0 animations:^{
        self.cameraUI.view.transform = CGAffineTransformMakeTranslation(0, -self.cameraUI.view.frame.size.height);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self performSegueWithIdentifier:@"poi" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.populars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"map" forIndexPath:indexPath];
    cell.textLabel.text = self.populars[indexPath.row][@"title"];
    return cell;
}

- (void)camera:(TICameraControllerViewController *)controller didCreatePOI:(TIPointOfInterest *)point
{
    point.location = self.bestGuess;
    [point save:^{
        PFQuery *query = [PFQuery queryWithClassName:@"PointOfInterest"];
        query.limit = 100;
        [query findObjectsInBackgroundWithTarget:self selector:@selector(setPopularPOIs:)];

    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidCancel:(TICameraControllerViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];    
}

 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[TIMapController class]])
    {
        TIPointOfInterest *selectedPOI = self.populars[[self.tableView indexPathForSelectedRow].row];
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setSelectedPOI:selectedPOI];
    }
    else if ([segue.identifier isEqualToString:@"camera"])
    {
        ((TICameraControllerViewController *)((UINavigationController *)segue.destinationViewController).topViewController).delegate = self;
        ((TICameraControllerViewController *)((UINavigationController *)segue.destinationViewController).topViewController).poi = [[TIPointOfInterest alloc] init];
    }
}

- (void)mapController:(TIMapController *)controller didSomething:(id)object
{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.bestGuess = ((CLLocation*)locations.lastObject).coordinate;
    [self.manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Starting the location manager");
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Done with velocity: %f", [sender velocityInView:self.view].y);
                
        [UIView animateWithDuration:MIN(-self.cameraUI.view.transform.ty / [sender velocityInView:self.view].y, 1.0) animations:^{
            self.cameraUI.view.transform = CGAffineTransformIdentity;
        } ];
    }
    else
    {
        CGPoint translation = [sender translationInView:self.view];
        NSLog(@"Translation: %f -> %f", self.cameraUI.view.transform.ty, translation.y);
        self.cameraUI.view.transform = CGAffineTransformMakeTranslation(0, self.cameraUI.view.transform.ty + translation.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

- (IBAction)openCamera:(id)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.cameraUI.view.transform = CGAffineTransformIdentity;
    } ];
}
@end
