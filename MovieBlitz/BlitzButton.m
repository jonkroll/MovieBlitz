//
//  BlitzButton.m
//  TestAnimation
//
//  Created by Jon Kroll on 1/30/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import "BlitzButton.h"
#import "Actor.h"
#import "Movie.h"
#import "UIImageView+WebCache.h"

@implementation BlitzButton

@synthesize item = _item;
@synthesize position = _position;

- (id)initWithItem:(NSManagedObject*)obj forPositionNumber:(NSInteger)num
{
    self = [super init];
    
    if (self) {
        
        self.item = obj;
        self.position = num;
        
        int ypos = 170+((num-1) * 60);
        self.frame = CGRectMake(-280, ypos, 280, 54);
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor grayColor] CGColor];
        self.layer.cornerRadius = 10;
        [self.layer setMasksToBounds:YES];
         
        UILabel *buttonText = [[UILabel alloc] initWithFrame:CGRectMake(50,0,220,54)];
        buttonText.textColor = [UIColor colorWithRed:50.0/255 green:79.0/255 blue:133.0/255 alpha:1.0];
        buttonText.backgroundColor = [UIColor clearColor];
        buttonText.font = [UIFont boldSystemFontOfSize:14.0];
        buttonText.userInteractionEnabled = NO;
        [self addSubview:buttonText];
        
        NSURL *imgUrl;
        NSString *placeholderImageName;
        
        if ([obj isKindOfClass:[Actor class]]) {
            buttonText.text = [(Actor*)obj name];
            imgUrl = [NSURL URLWithString:[(Actor*)obj image]];
            placeholderImageName = @"no-profile-w92.jpg";
        } else {
            Movie *movie = (Movie*)obj;
            buttonText.text = [NSString stringWithFormat:@"%@ (%@)", movie.title, movie.year];            
            imgUrl = [NSURL URLWithString:[(Movie*)obj image]];
            placeholderImageName = @"no-poster-w92.jpg";
        }
                
        UIImageView *photo = [[UIImageView alloc] init];
        [photo setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:placeholderImageName]];        
        photo.frame = CGRectMake(0, 0, 38, 54);
        photo.userInteractionEnabled = NO;
        [self addSubview:photo];
        
    }
    return self;
}

- (void)slideInWithDelay:(float)secondsToDelay
{
    [UIView animateWithDuration:0.5
                        delay:secondsToDelay
                      options: UIViewAnimationOptionCurveEaseOut 
                   animations:^{
                         CGPoint p = self.center;
                         p.x += 310;
                         self.center = p;
                   } 
                   completion:^(BOOL finished){
 

                       
                       [UIView animateWithDuration:0.1
                                               delay:0
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              CGPoint p = self.center;
                                              p.x -= 10;
                                              self.center = p;
                                          } 
                                          completion:^(BOOL finished){
                                              //done

/*                                              
                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                              if ([[defaults objectForKey:@"sounds"] isEqualToString:@"on"]) {
                                                  
                                                  //[(AppDelegate *)[[UIApplication sharedApplication] delegate] playSound:@"click";
                                                  
                                                  SystemSoundID soundID;                       
                                                  OSStatus err = kAudioServicesNoError;
                                                  NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
                                                  NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
                                                  err = AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL, &soundID);                       
                                                  if (err == kAudioServicesNoError) {
                                                      // set up callback for sound completion
                                                      //err = AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,SystemSoundsDemoCompletionProc,NULL); 
                                                      AudioServicesPlaySystemSound (soundID); 
                                                  }
                                                  
                                              }
*/                                              
                                          }
                        ];
                   }];    
}


- (void)slideOutWithDelay:(float)secondsToDelay
{
    [UIView animateWithDuration:0.1
                          delay:secondsToDelay
                        options: UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         CGPoint p = self.center;
                         p.x -= 10;
                         self.center = p;
                     } 
                     completion:^(BOOL finished){
                                                  
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         if ([[defaults objectForKey:@"sounds"] isEqualToString:@"on"]) {
                             
                             //[(AppDelegate *)[[UIApplication sharedApplication] delegate] playSound:@"pop2"];

                             SystemSoundID soundID;                       
                             OSStatus err = kAudioServicesNoError;
                             NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"pop2" ofType:@"wav"];
                             NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
                             err = AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL, &soundID);                       
                             if (err == kAudioServicesNoError) {
                                 // set up callback for sound completion
                                 //err = AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,SystemSoundsDemoCompletionProc,NULL); 
                                 AudioServicesPlaySystemSound (soundID); 
                             }
 
                         }
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGPoint p = self.center;
                                              p.x += 310;
                                              self.center = p;
                                          } 
                                          completion:^(BOOL finished){
                                              [self removeFromSuperview];   
                                          }];
                     }];   
}


- (void)sendToTopWithDelay:(float)secondsToDelay
{
    [UIView animateWithDuration:0.5
                          delay:secondsToDelay
                        options: UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         CGPoint p = self.center;
                         p.y = 76;
                         self.center = p;
                     } 
                     completion:^(BOOL finished){
                         // done
                     }];   
}

@end
