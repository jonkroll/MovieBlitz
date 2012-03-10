//
//  MBActorQuestion.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import "MBActorQuestion.h"
#import "Role.h"
#import "NSMutableArray+Utils.h"

@implementation MBActorQuestion

@synthesize actor = _actor;
@synthesize movies = _movies;
@synthesize correctAnswer = _correctAnswer;
@synthesize role = _role;

/*
 - (NSMutableArray*)movies {
    
    // lazy instantiate
    if (!_movies) {
        _movies = [NSMutableArray arrayWithCapacity:0];
    }
    return _movies;
}
 */

+ (id)actorQuestionFromContext:(NSManagedObjectContext*)context
{
    NSError *error = nil;
    NSFetchRequest *request;
    
    // pick random actor
    // determine number of actors in db
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Actor" inManagedObjectContext:context]];
    [request setIncludesSubentities:NO];
    NSUInteger numActors = [context countForFetchRequest:request error:&error];
    if(numActors == NSNotFound) {
        //Handle error
        
        return nil;
    }
    int r = arc4random() % numActors;
    
    // get the actor at that index
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Actor" inManagedObjectContext:context]];
    [request setFetchOffset:r];
    [request setFetchLimit:1];
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (!array || array.count == 0){
        // handle error
        
        return nil;
    }
    return [MBActorQuestion actorQuestionFromContext:(NSManagedObjectContext*)context 
                                            forActor:(Actor*)[array objectAtIndex:0]
                                              butNot:nil];
}

+ (id)actorQuestionFromContext:(NSManagedObjectContext*)context forActor:(Actor*)actor butNot:(Movie*)lastMovieUsed
{
    MBActorQuestion *question = [[MBActorQuestion alloc] init];
    
    question.actor = actor;
    question.movies = [NSMutableArray arrayWithCapacity:0];
    
    
    // pick random movie starring that actor
    int numMovieRoles = [actor.roles count];
    
    Role *role;
    do {
        int randomlySelectedIndex = arc4random() % numMovieRoles;
        role = [[actor.roles allObjects] objectAtIndex:randomlySelectedIndex];
    } while (lastMovieUsed && role.movie == lastMovieUsed);
    
    [question.movies addObject:role.movie];    
    question.role = role;
    question.correctAnswer = role.movie;
    
    // pick three actors who did not appear in that movie
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"actor.name <> %@", actor.name];    
    
    // determine number of roles in db
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Role" inManagedObjectContext:context]];
    [request setPredicate:predicate];    
    [request setIncludesSubentities:NO];
    NSUInteger numRoles = [context countForFetchRequest:request error:&error];
    
    while (question.movies.count < 4) {
        
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

            Role *role = (Role*)[array objectAtIndex:0];
            
            // make sure that the movie does not already appear in the movies array
            for (Movie *movie in question.movies) {
                if ([movie.title isEqualToString:role.movie.title]) {
                    role = nil;
                    break;
                }
            }
            
            // make sure the movie didn't star the actor for the question
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"movie.title = %@ and actor.name = %@", role.movie.title, actor.name];
            
            NSError *error = nil;
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Role" inManagedObjectContext:context]];
            [request setPredicate:predicate2];    
            [request setIncludesSubentities:NO];
            NSUInteger numRoles = [context countForFetchRequest:request error:&error];
            
            if (numRoles > 0) {
                role = nil;
            }
            
            if (role) {
                [question.movies addObject:role.movie];
            }
        } 
    }
    
    [question.movies shuffle];
    
    return question;
}

- (BOOL) isCorrectAnswer:(Actor *)movie
{
    Role *role;
    for (role in self.actor.roles) {
        if ([role.movie isEqual:movie] && [role.actor isEqual:self.actor]) {
            return YES;
        }
    }
    return NO;
}

@end
