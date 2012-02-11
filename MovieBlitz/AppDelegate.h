//
//  AppDelegate.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/1/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKRSAppSoundPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) VKRSAppSoundPlayer *appSoundPlayer;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (void)playSound:(NSString *)sound;

@end
