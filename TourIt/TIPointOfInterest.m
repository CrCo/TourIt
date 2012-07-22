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

- (void)save: (void (^)()) block
{
    void (^safeCopy)() = [block copy];
    PFObject *object = [PFObject objectWithClassName:@"PointOfInterest"];
    [object setObject:self.title forKey:@"title"];
    [object setObject:self.details forKey:@"description"];
    [object setObject:self forKey:@"group"];

    [object setObject:[PFGeoPoint geoPointWithLatitude:self.location.latitude longitude:self.location.longitude] forKey:@"location"];
    
    if (self.image)
    {
        NSLog(@"We have an image…");
        // Upload image
        NSData *data = UIImagePNGRepresentation(self.image);
        PFFile *file = [PFFile fileWithData: data];
        NSLog(@"Starting the upload of %d bytes", data.length);
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                NSLog(@"File saving succeeded. Bryan sucks");
            }else {
                NSLog(@"Saving file bombed because: %@", error.localizedDescription);
            }
            [object setObject:file forKey:@"picture"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    NSLog(@"The main object was saved like a bitch.");
                }else{
                    NSLog(@"Saving the main object: %@", error.localizedDescription);
                }
                safeCopy();
            }];
        }];
    }
    else
    {
        [object saveInBackground];
    }
}

@end
