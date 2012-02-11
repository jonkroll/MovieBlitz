//
//  MBGame.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import "MBGame.h"

@implementation MBGame

@synthesize score = _score;
@synthesize currentQuestion = _currentQuestion;
@synthesize numLifelines = _numLifelines;

- (id)init
{
    self = [super init];
    if (self) {
        _score = 0;
        _numLifelines = 3;
    }
    return self;
}


- (NSArray*)useLifeline
{
    
    NSArray *elimatedAnswers = [[NSArray alloc] initWithObjects:nil];
    
    return elimatedAnswers;
}

@end
