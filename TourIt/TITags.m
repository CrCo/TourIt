//
//  TITags.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TITags.h"
#import <Parse/Parse.h>

@implementation TITags

+ (void) tagsForString:(NSString*)text withCallback:(void(^)(NSArray *results)) callback;
{
    void(^safeCopy)(NSArray *results) = [callback copy];
    
    if (text)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"PointOfInterest"];
        [query whereKey:@"group" hasPrefix:text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            safeCopy(objects);
        }];
    }
    else
    {
        PFQuery *query = [PFQuery queryWithClassName:@"PointOfInterest"];
        [query whereKeyExists:@"group"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            safeCopy(objects);
        }];
    }
}

@end
