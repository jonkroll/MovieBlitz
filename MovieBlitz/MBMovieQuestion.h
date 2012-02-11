//
//  MBMovieQuestion.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBQuestion.h"
#import "Actor.h"
#import "Movie.h"
#import "Role.h"

@interface MBMovieQuestion : MBQuestion

@property (nonatomic, strong) Movie *movie;
@property (nonatomic, strong) NSMutableArray *actors;
@property (nonatomic, strong) Role *role;
@property (nonatomic, strong) Actor *correctAnswer;

+ (id)movieQuestionFromContext:(NSManagedObjectContext*)context;
+ (id)movieQuestionFromContext:(NSManagedObjectContext*)context forMovie:(Movie*)movie butNot:(Actor*)lastActorUsed;

- (BOOL)isCorrectAnswer:(Actor*)actor;

@end
