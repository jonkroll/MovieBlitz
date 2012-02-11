//
//  MBGame.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBQuestion.h"

@interface MBGame : NSObject

@property (nonatomic) NSInteger score;
@property (nonatomic, strong) MBQuestion *currentQuestion;
@property (nonatomic) NSInteger numLifelines;

- (NSArray*)useLifeline;  // returns array of eliminated answers

@end