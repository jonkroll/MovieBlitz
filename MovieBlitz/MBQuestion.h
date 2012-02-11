//
//  MBQuestion.h
//  MovieBlitz
//
//  Created by Jon Kroll on 2/4/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MBQuestion : NSObject

- (BOOL)isCorrectAnswer:(NSManagedObject*)obj;

@end
