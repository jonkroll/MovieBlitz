//
//  GameOverView.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/10/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBQuestion.h"

@interface GameOverViewController : UIViewController

@property (nonatomic, strong) MBQuestion *finalQuestion;
@property (nonatomic, strong) UIImage *miniImage;

@property (nonatomic, strong) IBOutlet UILabel *gameOverText;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;

- (IBAction)clickContinueButton:(UIButton*)sender;

@end
