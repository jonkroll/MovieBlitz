//
//  BlitzButton.h
//  TestAnimation
//
//  Created by Jon Kroll on 1/30/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Actor.h"
#import "Movie.h"

@interface BlitzButton : UIButton

@property (nonatomic, strong) NSManagedObject* item;
@property (nonatomic) NSInteger position;

- (id)initWithItem:(NSManagedObject*)obj forPositionNumber:(NSInteger)num;

//- (id)eliminate;

- (void)slideInWithDelay:(float)secondsToDelay;
- (void)slideOutWithDelay:(float)secondsToDelay;
- (void)sendToTopWithDelay:(float)secondToDelay;
@end
