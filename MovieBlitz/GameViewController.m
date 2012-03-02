//
//  GameViewController.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GameViewController.h"
#import "NSMutableArray+Utils.h"
#import "BlitzButton.h"
#import "MBQuestion.h"
#import "MBMovieQuestion.h"
#import "MBActorQuestion.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "GameOverViewController.h"

@interface GameViewController ()
{
    SystemSoundID silenceSound;  // 1 second of quiet
    SystemSoundID popSound;
    SystemSoundID clickSound;
    SystemSoundID dingSound;
    SystemSoundID bummerSound;
}
- (void)updateLifelinesLabel;
- (void)transitionToNextQuestion;
- (void)activateButtons;
- (void)handleWrongAnswer;
- (void)registerSoundWithResource:(NSString*)resource ofType:(NSString*)type intoID:(SystemSoundID*)soundID;
void SoundFinished (SystemSoundID snd, void* context);
@end

#pragma mark -

@implementation GameViewController

@synthesize game = _game;
@synthesize scoreLabel = _scoreLabel;
@synthesize currentQuestionLabel = _currentQuestionLabel;
@synthesize currentButtons = _currentButtons;
@synthesize lifelinesButton = _lifelinesButton;
@synthesize lifelinesLabel = _lifelinesLabel;


- (id)initWithCoder:(NSCoder *)aDecoder 
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self registerSoundWithResource:@"silence" ofType:@"wav" intoID:&silenceSound];
        [self registerSoundWithResource:@"pop2" ofType:@"wav" intoID:&popSound];
        [self registerSoundWithResource:@"click" ofType:@"wav" intoID:&clickSound];
        [self registerSoundWithResource:@"ding" ofType:@"wav" intoID:&dingSound];
        [self registerSoundWithResource:@"bummer" ofType:@"wav" intoID:&bummerSound];

        // need to play a dummy sound here, otherwise the first played sound gets delayed
        AudioServicesPlaySystemSound(silenceSound);   
    }
    return self;
}


#pragma mark - Getters

- (NSMutableArray*)currentButtons
{
    // lazy instantiate
    if (!_currentButtons) {
        _currentButtons = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _currentButtons;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _game = [[MBGame alloc] init];
    
    [self updateLifelinesLabel];

    self.view.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];    
    NSManagedObjectContext *context = appDelegate.context;
    
    [self showQuestion:[MBMovieQuestion movieQuestionFromContext:context]];

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


#pragma mark - Game Methods

- (void)showQuestion:(MBQuestion*)q
{
    self.game.currentQuestion = q;
    [self.currentButtons removeAllObjects];
    
    if (self.game.numLifelines > 0) {
        [self.lifelinesButton setEnabled:YES];
        [self.lifelinesButton setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0]
                     forState:UIControlStateNormal];
    }
    
    NSString *questionText;
    
    if ([q isKindOfClass:[MBMovieQuestion class]]) {
        
        MBMovieQuestion *question = (MBMovieQuestion*)q;
        
        NSString *title = question.movie.title;
        NSString *characterName = question.role.characterName;

        questionText = [NSString stringWithFormat:@"In the movie %@, which actor played %@?", title, characterName];
        
    } else {

        MBActorQuestion *question = (MBActorQuestion*)q;

        NSString *name = question.actor.name;
        NSString *characterName = question.role.characterName;
        
        questionText = [NSString stringWithFormat:@"Which movie starred %@ as %@?", name, characterName];

    }
        
    if (self.game.score == 0) {
        
        // make a pseduo BlitzButton here
        //   TODO - genericize the BlitzButton class to we don't duplicate code

        UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(20,50,280,54)];
        
        UIView *bg = [[UIView alloc] initWithFrame:topButton.bounds];
        bg.backgroundColor = [UIColor whiteColor];
        bg.userInteractionEnabled = NO;
        [topButton addSubview:bg];
        
        bg.layer.borderWidth = 1;
        bg.layer.borderColor = [[UIColor grayColor] CGColor];
        bg.layer.cornerRadius = 10;
        [bg.layer setMasksToBounds:YES];
     
        UILabel *buttonText = [[UILabel alloc] initWithFrame:CGRectMake(50,0,220,54)];
        buttonText.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
        buttonText.backgroundColor = [UIColor clearColor];
        buttonText.font = [UIFont boldSystemFontOfSize:14.0];
        buttonText.userInteractionEnabled = NO;
        [bg addSubview:buttonText];
        
        MBMovieQuestion *question = (MBMovieQuestion*)q;

        buttonText.text = [NSString stringWithFormat:@"%@ (%@)", question.movie.title, question.movie.year];            
        NSURL *imgUrl = [NSURL URLWithString:question.movie.image];
        UIImageView *photo = [[UIImageView alloc] init];
        [photo setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"no-poster-w92.jpg"]];
        photo.frame = CGRectMake(0,0, 38,54);
        photo.userInteractionEnabled = NO;
        [bg addSubview:photo];
        
        [self.view addSubview:topButton];
        
    }
    
    self.currentQuestionLabel.text = questionText;
    self.currentQuestionLabel.alpha = 1.0;
        
    float delay = 0.2;
    BlitzButton* button;
    
    for (int i=0; i < 4; i++) {
        if ([q isKindOfClass:[MBMovieQuestion class]]) {
            button = [[BlitzButton alloc] initWithItem:[[(MBMovieQuestion*)q actors] objectAtIndex:i] 
                                      forPositionNumber:i+1];
        } else {
            button = [[BlitzButton alloc] initWithItem:[[(MBActorQuestion*)q movies] objectAtIndex:i] 
                                      forPositionNumber:i+1];            
        }
        [self.currentButtons addObject:button];
        [self.view addSubview:button];   
        
        button.delegate = self;

        [button slideInWithDelay:(delay += 0.2)];
    }
    
    [self performSelector:@selector(activateButtons) withObject:nil afterDelay:1.2];
    
}

- (void)activateButtons
{
    BlitzButton * button;
    for (button in self.currentButtons) {
        [button addTarget:self action:@selector(selectAnswer:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(highlightButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchDragOutside];
    }
}

- (IBAction)quitGame:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateLifelinesLabel
{
    NSString *lifelinesWord = (self.game.numLifelines == 1) ? @"Lifeline" : @"Lifelines";
    self.lifelinesLabel.text = [NSString stringWithFormat:@"%i %@ Remaining", self.game.numLifelines, lifelinesWord];
}



- (IBAction)highlightButton:(BlitzButton*)sender
{
    UIView *view;
    sender.backgroundColor = [UIColor blueColor];
    for (view in sender.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [(UILabel*)view setTextColor:[UIColor whiteColor]];
        }
    }
}


- (IBAction)unhighlightButton:(BlitzButton*)sender
{    
    UIView *view;
    sender.backgroundColor = [UIColor whiteColor];
    for (view in sender.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [(UILabel*)view setTextColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0]];
        }
    }
}


- (IBAction)selectAnswer:(BlitzButton*)sender
{
    UIView *view;
    
    sender.backgroundColor = [UIColor whiteColor];
    for (view in sender.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [(UILabel*)view setTextColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0]];
        }
    }

    
    // remove touchability from all buttons
    BlitzButton *button;
    for (button in self.currentButtons) {
        [button removeTarget:self action:@selector(selectAnswer:) forControlEvents:UIControlEventTouchUpInside];
        [button removeTarget:self action:@selector(highlightButton:) forControlEvents:UIControlEventTouchDown];
        [button removeTarget:self action:@selector(unhighlightButton:) forControlEvents:UIControlEventTouchDragOutside];
    }
    
        
    // check if selected answer was correct
    if ([self.game.currentQuestion isCorrectAnswer:((BlitzButton*)sender).item]) {

        // show checkmark
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tick" ofType:@"png"];
        UIImageView *tickImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
        tickImageView.frame = CGRectMake(240, 10, 32, 32);
        
        [sender addSubview:tickImageView];
        
        [UIView animateWithDuration:1.0
                              delay:1.0
                            options: UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
                             
                             // fade out tick mark
                             [tickImageView setAlpha:0.0];
                             
                         } 
                         completion:^(BOOL finished){
                             [tickImageView removeFromSuperview];
                         }];

        [self transitionToNextQuestion];
        
/* 
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"sounds"] isEqualToString:@"on"]) {
           
            // play ding sound

            SystemSoundID soundID;                       
            OSStatus err = kAudioServicesNoError;
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"wav"];
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
            err = AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL, &soundID);                       
            if (err == kAudioServicesNoError) {
                // set up callback for sound completion
                
                GameViewController *data = self; 
                
                err = AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,dingSoundFinished,(__bridge void*)data); 
                AudioServicesPlaySystemSound (soundID); 
            } else {
                [self transitionToNextQuestion];
            }
        } else {
            [self transitionToNextQuestion];           
        }
 */
        
    } else {
        
        NSLog(@"Incorrect Answer...");

        // show red 'X'
        NSString *path = [[NSBundle mainBundle] pathForResource:@"wrong" ofType:@"png"];
        UIImageView *tickImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
        tickImageView.frame = CGRectMake(240, 10, 32, 32);
        
        [sender addSubview:tickImageView];
        
        [UIView animateWithDuration:1.0
                              delay:1.0
                            options: UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
                             
                             // fade out x mark
                             [tickImageView setAlpha:0.0];
                             
                         } 
                         completion:^(BOOL finished){
                             // do nothing
                         }];
        
        /*
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"sounds"] isEqualToString:@"on"]) {
            
            //[(AppDelegate *)[[UIApplication sharedApplication] delegate] playSound:@"bummer"];
            
            SystemSoundID soundID;                       
            OSStatus err = kAudioServicesNoError;
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"bummer" ofType:@"wav"];
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
            err = AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL, &soundID);                       
            if (err == kAudioServicesNoError) {
                // set up callback for sound completion
                //err = AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,SystemSoundsDemoCompletionProc,NULL); 
                AudioServicesPlaySystemSound (soundID); 
            }
            
        }
        
*/
         
        [self performSelector:@selector(handleWrongAnswer) withObject:nil afterDelay:1.0];
        
    }
}

- (IBAction)useLifeline:(UIButton*)sender
{
    if (self.game.numLifelines > 0) {
        
        [sender setEnabled:NO];
        [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.game.numLifelines--;
        [self updateLifelinesLabel];
        [self.lifelinesLabel setNeedsDisplay];
        
        // pick two questions to eliminate
        NSMutableSet *eliminateButtons = [NSMutableSet setWithCapacity:0];
        while ([eliminateButtons count] < 2) {
            
            int r = arc4random() % self.currentButtons.count;
            BlitzButton *button = (BlitzButton*)[self.currentButtons objectAtIndex:r];
            if (![self.game.currentQuestion isCorrectAnswer:button.item] &&
                ![eliminateButtons containsObject:button]) {
                [eliminateButtons addObject:button];
            }
        }
        
        BlitzButton * button;
        float delay = 0.02;
        for (button in eliminateButtons) {
            [self.currentButtons removeObject:button];
            [button slideOutWithDelay:delay];
            delay += 0.2;
        }
    }
}

//static void dingSoundFinished(SystemSoundID soundID, void *data) {
//    
//    [(__bridge GameViewController*)data transitionToNextQuestion];
//}

- (void)transitionToNextQuestion
{
    float delay = -0.2;
    BlitzButton *button;
    
    NSMutableArray *incorrectAnswers = [NSMutableArray arrayWithObjects:nil];
    BlitzButton *correctAnswer;
    
    for (button in self.currentButtons) {            
        if ([self.game.currentQuestion isCorrectAnswer:button.item]) {
            correctAnswer = button;
        } else {
            [incorrectAnswers addObject:button];
        }
    }
    
    [incorrectAnswers shuffle];
    
    for (button in incorrectAnswers) {
        [button slideOutWithDelay:(delay+=0.2)];
    }         
    
    [correctAnswer sendToTopWithDelay:1.0];
    
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         
                         // fade out question text
                         [self.currentQuestionLabel setAlpha:0.0];
                         
                     } 
                     completion:^(BOOL finished){
                         // done
                         
                         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];    
                         NSManagedObjectContext *context = appDelegate.context;
                         
                         NSManagedObject* item = [correctAnswer item];
                         
                         // remove top button for just-answered question
                         UIView *view;
                         for (view in [self.view subviews]) {
                             if ([view isKindOfClass:[BlitzButton class]]) {
                                 NSManagedObject *item = [(BlitzButton*)view item];
                                 if (([self.game.currentQuestion isKindOfClass:[MBMovieQuestion class]] && 
                                       [item isEqual:[(MBMovieQuestion*)self.game.currentQuestion movie]])
                                     ||
                                     ([self.game.currentQuestion isKindOfClass:[MBActorQuestion class]] && 
                                      [item isEqual:[(MBActorQuestion*)self.game.currentQuestion actor]])) {
                                         [view removeFromSuperview];
                                     }
                             }
                         }
                         
                         
                         if ([item isKindOfClass:[Actor class]]) {
                             [self showQuestion:[MBActorQuestion actorQuestionFromContext:context 
                                                                                 forActor:(Actor*)item
                                                                                   butNot:[(MBMovieQuestion*)self.game.currentQuestion movie] ]];
                             
                         } else {
                             
                             [self showQuestion:[MBMovieQuestion movieQuestionFromContext:context 
                                                                                 forMovie:(Movie*)item
                                                                                   butNot:[(MBActorQuestion*)self.game.currentQuestion actor]]];
                         }
                         
                     }];  
    
    self.game.score++;
    
    if (self.game.score % 10 == 0) {
        
        self.game.numLifelines++;
        [self updateLifelinesLabel];
        
        [self.lifelinesButton setEnabled:YES];
        [self.lifelinesButton setTitleColor:[UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0]
                                   forState:UIControlStateNormal];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%i",self.game.score];
    [self.scoreLabel setNeedsDisplay];

    // show star
    NSString *path = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"];
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    starImageView.alpha = 1.0;
    starImageView.frame = CGRectMake((self.scoreLabel.frame.size.width/2) - 8, (self.scoreLabel.frame.size.height/2) - 8, 16, 16);
 
    
    [self.scoreLabel addSubview:starImageView];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         
                         // fade in star
                         [starImageView setAlpha:0.0];
                         starImageView.frame = CGRectMake((self.scoreLabel.frame.size.width/2) + 4, 
                                                          (self.scoreLabel.frame.size.height/2) - 12, 12, 12);
                         
                     } 
                     completion:^(BOOL finished){

                         [starImageView removeFromSuperview];
                     }];

}


- (void)handleWrongAnswer
{
    [self performSegueWithIdentifier:@"GameOver" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GameOver"])
    {
        GameOverViewController *vc = [segue destinationViewController];        
        [vc setFinishedGame:self.game];

        // save miniimage from the button so we know the correct dimensions for the larger version
        // we'll show on the next view
        BlitzButton *button;
        for (button in self.currentButtons) {
            if ([self.game.currentQuestion isCorrectAnswer:button.item]) {
                UIView *view;
                for (view in [button subviews]) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        
                        UIImage* image = (UIImage*)view;
                        
                        [vc setMiniImage:[(UIImageView*)view image]];
                        
                        float aspectRatio = image.size.width / image.size.height;
                        
                        [vc setImageAspectRatio:aspectRatio];
                        
                        
                    }
                }
            }
        }        
    }
}


#pragma mark - BlitzButton Delegate

- (void)button:(BlitzButton*)button didFinishMoveType:(BlitzButtonMoveType) type {

    if (type == BlitzButtonMoveTypeSlideIn) {
        // play click sound when button slides in
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"sounds"] isEqualToString:@"on"]) {

            AudioServicesPlaySystemSound(clickSound);  
        }
    }

}

- (void)button:(BlitzButton*)button didStartMoveType:(BlitzButtonMoveType) type {
    
    if (type == BlitzButtonMoveTypeSlideOut) {
        // play pop sound when button slides out
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"sounds"] isEqualToString:@"on"]) {
          
            AudioServicesPlaySystemSound(popSound);   

        }
    }
}

#pragma mark - Audio functions

- (void)registerSoundWithResource:(NSString*)resource ofType:(NSString*)type intoID:(SystemSoundID*)soundID
{
    // register system sounds
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    if (soundPath) {
        NSURL * soundURL = [NSURL fileURLWithPath:soundPath];
        OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, soundID);
        if (err != kAudioServicesNoError) {
            NSLog(@"Could not load %@, error code: %ld", soundURL, err);
        }
    }   
}

void SoundFinished (SystemSoundID snd, void* context) {
    AudioServicesRemoveSystemSoundCompletion(snd);
    AudioServicesDisposeSystemSoundID(snd); }

@end
