//
//  Role.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/3/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Movie;

@interface Role : NSManagedObject

@property (nonatomic, strong) NSNumber * billing;
@property (nonatomic, strong) NSString * characterName;
@property (nonatomic, strong) Actor *actor;
@property (nonatomic, strong) Movie *movie;

@end
