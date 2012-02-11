//
//  Actor.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/3/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Role;

@interface Actor : NSManagedObject

@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *roles;
@end

@interface Actor (CoreDataGeneratedAccessors)

- (void)addRolesObject:(Role *)value;
- (void)removeRolesObject:(Role *)value;
- (void)addRoles:(NSSet *)values;
- (void)removeRoles:(NSSet *)values;

@end
