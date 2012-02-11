//
//  NonAnimatedSegue.m
//  MovieBlitz
//
//  Created by Jon Kroll on 2/10/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "NonAnimatedSegue.h"

@implementation NonAnimatedSegue

@synthesize appDelegate = _appDelegate;

-(void) perform{
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end