//
//  GameOverView.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/10/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GameOverViewController.h"
#import "UIImageView+WebCache.h"
#import "MBMovieQuestion.h"
#import "MBActorQuestion.h"


@implementation GameOverViewController

@synthesize finalQuestion = _finalQuestion;
@synthesize miniImage = _miniImage;
@synthesize gameOverText = _gameOverText;
@synthesize imgView = _imgView;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *imgUrl;
    NSString *gameOverText;
    NSString *imgString;
    
    if ([self.finalQuestion isKindOfClass:[MBMovieQuestion class]]) {
        
        Actor* actor = [(MBMovieQuestion*)self.finalQuestion correctAnswer];
        gameOverText = [NSString stringWithFormat:@"Sorry.\nThe correct answer was\n%@", actor.name];
        
         imgString = [actor.image stringByReplacingOccurrencesOfString:@"/w45/" withString:@"/w185/"];

        NSLog(@"%@", actor.image);
    } else {

        Movie* movie = [(MBActorQuestion*)self.finalQuestion correctAnswer];
        gameOverText = [NSString stringWithFormat:@"Sorry. The correct answer was\n%@", movie.title];
        imgUrl = [NSURL URLWithString:movie.image];

        imgString = [movie.image stringByReplacingOccurrencesOfString:@"/w92/" withString:@"/w185/"];

        NSLog(@"%@", movie.image);
    }
    
    imgUrl = [NSURL URLWithString:imgString];
    
    
    
    
   
    if (self.miniImage) {
        int imgHeight = 200;
        
        int imgWidth = self.miniImage.size.width * imgHeight / self.miniImage.size.width;

        int imgFrameOriginX = ((320 - imgWidth) /2) - 10;
        int imgFrameOriginY = ((480 - imgHeight) /2) - 10; 
        
         UIImageView *fullImgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgFrameOriginX, imgFrameOriginY, 
                                                                               imgWidth + 20, imgHeight + 20)];
        

        
        [fullImgView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]]; 
        
        fullImgView.backgroundColor = [UIColor whiteColor];
        fullImgView.contentMode = UIViewContentModeCenter;
        
        fullImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        fullImgView.layer.borderWidth = 1.0;
        fullImgView.layer.cornerRadius = 5.0;
        fullImgView.layer.masksToBounds = NO;
        fullImgView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        fullImgView.layer.shadowColor = [UIColor grayColor].CGColor;
        fullImgView.layer.shadowOpacity = 0.8;
        fullImgView.layer.shadowRadius = 1.0;
        
        fullImgView.clipsToBounds = YES;
        
        [self.view addSubview:fullImgView];
    }
    
    self.gameOverText.text = gameOverText;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)clickContinueButton:(UIButton*)sender;
{    
    // back to home view
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
