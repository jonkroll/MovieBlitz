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

@class BlitzButton;

typedef enum 
{
    BlitzButtonMoveTypeSlideIn,
    BlitzButtonMoveTypeSlideOut,
    BlitzButtonMoveTypeSlideUp
} BlitzButtonMoveType;


@protocol BlitzButtonDelegate <NSObject>
@optional
- (void)button:(BlitzButton*)button didStartMoveType:(BlitzButtonMoveType) type;
- (void)button:(BlitzButton*)button didFinishMoveType:(BlitzButtonMoveType) type;
@end


@interface BlitzButton : UIButton

@property (nonatomic, strong) NSManagedObject* item;
@property (nonatomic) NSInteger position;
@property (nonatomic, weak) id <BlitzButtonDelegate> delegate;

- (id)initWithItem:(NSManagedObject*)obj forPositionNumber:(NSInteger)num;

- (void)slideInWithDelay:(float)secondsToDelay;
- (void)slideOutWithDelay:(float)secondsToDelay;
- (void)sendToTopWithDelay:(float)secondToDelay;

@end
