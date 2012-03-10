//
//  MBActorQuestion.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBQuestion.h"
#import "Actor.h"
#import "Movie.h"

@interface MBActorQuestion : MBQuestion

@property (nonatomic, strong) Actor *actor;
@property (nonatomic, strong) Role *role;
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) Movie *correctAnswer;

+ (id)actorQuestionFromContext:(NSManagedObjectContext*)context;
+ (id)actorQuestionFromContext:(NSManagedObjectContext*)context forActor:(Actor*)actor butNot:(Movie*)lastMovieUsed;

- (BOOL)isCorrectAnswer:(Movie*)movie;

@end
