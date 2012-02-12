//
//  GameOverView.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/10/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBGame.h"
#import "MBQuestion.h"

@interface GameOverViewController : UIViewController

@property (nonatomic, strong) MBGame *finishedGame;
@property (nonatomic, strong) UIImage *miniImage;

@property (nonatomic, strong) IBOutlet UILabel *gameOverText;
@property (nonatomic, strong) IBOutlet UILabel *yourScoreText;

- (IBAction)clickContinueButton:(UIButton*)sender;

@end
