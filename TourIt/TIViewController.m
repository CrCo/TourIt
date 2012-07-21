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

@end

@implementation TIViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        [self.manager startMonitoringSignificantLocationChanges];
    }
    return self;
}

- (void) setPopularPOIs: (NSArray *) pois
{
    self.populars = pois;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PointOfInterest"];
    query.limit = 10;
    [query findObjectsInBackgroundWithTarget:self selector:@selector(setPopularPOIs:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        return 44;
    }
    else
    {
        return 140;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section)
    {
        return [self.populars count];
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"map" forIndexPath:indexPath];
        cell.textLabel.text = self.populars[indexPath.row][@"title"];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tag" forIndexPath:indexPath];
        cell.textLabel.text = @"Map, yo!";
        return cell;
    }
}
- (void)camera:(TICameraControllerViewController *)controller didCreatePOI:(TIPointOfInterest *)point
{
    point.location = self.bestGuess;
    [point save];
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
    }
    else if ([segue.destinationViewController isKindOfClass:[TICameraControllerViewController class]])
    {
        ((TICameraControllerViewController *)segue.destinationViewController).delegate = self;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.bestGuess = ((CLLocation*)locations.lastObject).coordinate;
}

@end
