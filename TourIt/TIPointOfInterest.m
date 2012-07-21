//
//  TIPointOfInterest.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TIPointOfInterest.h"
#import <Parse/Parse.h>

@implementation TIPointOfInterest

- (void)save
{
    PFObject *object = [PFObject objectWithClassName:@"PointOfInterest"];
    [object setObject:self.title forKey:@"title"];
    [object setObject:self.details forKey:@"description"];

    [object setObject:[PFGeoPoint geoPointWithLatitude:self.location.latitude longitude:self.location.longitude] forKey:@"location"];
    
    if (self.image)
    {
        // Make itty bitty
        
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [self.image drawInRect: CGRectMake(0, 0, 640, 960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Upload image
        
        PFFile *file = [PFFile fileWithData: UIImagePNGRepresentation(smallImage)];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [object setObject:file forKey:@"picture"];
            [object saveInBackground];
        }];
    }
    else
    {
        [object saveInBackground];
    }
}

@end
