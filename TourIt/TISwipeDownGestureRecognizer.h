//
//  TISwipeDownGestureRecognizer.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-22.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TIPullDownGestureRecognizerDelegate <NSObject>

- (void) gestureRecognizer: (UIGestureRecognizer *) recognizer didMove: (CGFloat) distance;

@end

@interface TISwipeDownGestureRecognizer : UISwipeGestureRecognizer

@property (nonatomic, weak) id <TIPullDownGestureRecognizerDelegate,UIGestureRecognizerDelegate> delegate;
@property (nonatomic) CGFloat current;

@end
