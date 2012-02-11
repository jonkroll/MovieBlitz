//
//  HomeViewController.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/1/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "HomeViewController.h"
#import "Actor.h"
#import "Movie.h"
#import "MBMovieQuestion.h"
#import "MBActorQuestion.h"
#import "AppDelegate.h"
#import "GameViewController.h"

@implementation HomeViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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


@end
