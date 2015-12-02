//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "NSArray+CDXAdditions.h"
#import "CDXModelObject.h"

@implementation NSArray (CDXAdditions)

- (NSArray *)cdx_dictionaryRepresentation
{
    NSMutableArray *dictionaryReps = [NSMutableArray arrayWithCapacity:self.count];
    for (CDXModelObject *currObj in self) {
        [dictionaryReps addObject:currObj.dictionaryRepresentation];
    }
    return dictionaryReps;
}

@end
