//
//  TISwipeDownGestureRecognizer.m
//  TourIt
//
//  Created by Stephen Visser on 12-07-22.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import "TISwipeDownGestureRecognizer.h"

@implementation TISwipeDownGestureRecognizer

- (id)init
{
    self = [super init];
    if (self)
    {
        self.current = 0.0;
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.current += [touch locationInView:nil].y - [touch previousLocationInView:nil].y;
}


@end
