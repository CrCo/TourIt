//
//  TITags.h
//  TourIt
//
//  Created by Stephen Visser on 12-07-21.
//  Copyright (c) 2012 DreamTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TITags : NSObject

+ (void) tagsForString:(NSString*)text withCallback:(void(^)(NSArray *results)) callback;

@end
