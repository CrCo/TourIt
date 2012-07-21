//
//  TIViewController.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TIViewController.h"


// FIXME: Dummy data 
static NSArray *dummyData;

@interface TIViewController ()

@end

@implementation TIViewController

+ (void)initialize
{
    dummyData = @[@"Dragons", @"Celebrities", @"Brett's Children"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
        return [dummyData count];
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
        cell.textLabel.text = dummyData[indexPath.row];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tag" forIndexPath:indexPath];
        cell.textLabel.text = @"Map, yo!";
        return cell;
    }
}

@end
