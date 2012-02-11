//
//  MBMovieQuestion.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import "MBMovieQuestion.h"
#import "Role.h"
#import "Actor.h"
#import "NSMutableArray+Utils.h"

@implementation MBMovieQuestion

@synthesize movie = _movie;
@synthesize actors = _actors;
@synthesize correctAnswer = _correctAnswer;
@synthesize role = _role;

 - (NSMutableArray*)actors {
    
    // lazy instantiate
    if (!_actors) {
        _actors = [NSMutableArray arrayWithCapacity:0];
    }
    return _actors;
}

+ (id)movieQuestionFromContext:(NSManagedObjectContext*)context
{
    NSError *error = nil;
    NSFetchRequest *request;
    
    // pick random movie
    // determine number of movies in db
    request = [[NSFetchRequest alloc] init];

    [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
    //[request setIncludesSubentities:NO];

    NSUInteger numMovies = [context countForFetchRequest:request error:&error];

    if(numMovies == NSNotFound) {
        //Handle error
        
        return nil;
    }

    int r = arc4random() % numMovies;

    // get the movie at that index
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
    [request setFetchOffset:r];
    [request setFetchLimit:1];
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (!array || array.count == 0){
        // handle error
        
        return nil;
    }
    return [MBMovieQuestion movieQuestionFromContext:(NSManagedObjectContext*)context 
                                            forMovie:(Movie*)[array objectAtIndex:0]
                                              butNot:nil];
}

+ (id)movieQuestionFromContext:(NSManagedObjectContext*)context forMovie:(Movie*)movie butNot:(Actor*)lastActorUsed
{
    MBMovieQuestion *question = [[MBMovieQuestion alloc] init];
    
    question.movie = movie;
    
    // pick random actor from that movie
    int numActorRoles = [movie.roles count];
    Role *role;
    do {
        int randomlySelectedIndex = arc4random() % numActorRoles;
        role = [[movie.roles allObjects] objectAtIndex:randomlySelectedIndex];
    } while (lastActorUsed && role.actor == lastActorUsed);

    [question.actors addObject:role.actor];    
    question.role = role;
    question.correctAnswer = role.actor;
    
    // pick three actors who did not appear in that movie
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movie.title <> %@", movie.title];        

    // determine number of roles in db
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Role" inManagedObjectContext:context]];
    [request setPredicate:predicate];    
    [request setIncludesSubentities:NO];
    NSUInteger numRoles = [context countForFetchRequest:request error:&error];

    while (question.actors.count < 4) {

        int r = arc4random() % numRoles;

         request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Role" inManagedObjectContext:context]];
        [request setPredicate:predicate];
        [request setFetchOffset:r];
        [request setFetchLimit:1];
        
        NSArray *array = [context executeFetchRequest:request error:&error];
        if (!array) {
            // Deal with error...
        }
        
        if(array.count > 0){
         
            // TODO: make sure that the role's actor is not already in the actors array
            
            Role *role = (Role*)[array objectAtIndex:0];
            [question.actors addObject:role.actor];
        } 
    }
    
    [question.actors shuffle];
    
    return question;
}

- (BOOL) isCorrectAnswer:(Actor *)actor
{
    Role *role;
    for (role in self.movie.roles) {
        if ([role.actor isEqual:actor] && [role.movie isEqual:self.movie]) {
            return YES;
        }
    }
    return NO;
}

@end
