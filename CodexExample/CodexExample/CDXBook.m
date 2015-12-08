//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "CDXBook.h"

const struct CDXBookAttributes CDXBookAttributes = {
    .externalID = @"externalID",
    .title = @"title",
    .year = @"year",
    .tags = @"tags",
};

const struct CDXBookRelationships CDXBookRelationships = {
    .author = @"author",
};


@implementation CDXBook

+ (NSString *)entityName { return @"Book"; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"title: %@; year: %@, tags: %@, externalID: %@", self.title, self.year, self.tags, @(self.externalID)];
}

@end
