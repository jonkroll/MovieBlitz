//
//  GameViewController.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGame.h"

@interface GameViewController : UIViewController

@property (nonatomic, strong) MBGame *game;
@property (nonatomic, strong) UILabel *scoreLabel IBOutlet;
@property (nonatomic, strong) UILabel *currentQuestionLabel IBOutlet;
@property (nonatomic, strong) NSMutableArray *currentButtons;
@property (nonatomic, strong) UIButton *lifelinesButton IBOutlet;
@property (nonatomic, strong) UILabel *lifelinesLabel IBOutlet;

- (void)showQuestion:(MBQuestion*)question;
- (IBAction)quitGame:(id)sender;

@end
