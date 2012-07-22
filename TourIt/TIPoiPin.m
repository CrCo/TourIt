//
//  TIPoiPin.m
//  TourIt
//
//  Created by Brett Ohland on 12-07-22.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TIPoiPin.h"

@implementation TIPoiPin

@synthesize coordinate, title, subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    return self;
}

@end