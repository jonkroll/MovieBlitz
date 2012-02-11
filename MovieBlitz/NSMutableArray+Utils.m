//
//  NSMutableArray+Utils.m
//  MovieBlitz
//
//  Created by Jon Kroll on 1/28/12.
//  Copyright (c) 2012 Optionetics. All rights reserved.
//

#import "NSMutableArray+Utils.h"

@implementation NSMutableArray (Utils)

- (void)shuffle {
    
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
}

@end
