//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "ELTBook.h"

const struct ELTBookAttributes ELTBookAttributes = {
    .externalID = @"externalID",
    .title = @"title",
    .year = @"year",
    .tags = @"tags",
};

const struct ELTBookRelationships ELTBookRelationships = {
    .author = @"author",
};


@implementation ELTBook

+ (NSString *)entityName { return @"Book"; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"title: %@; year: %@, tags: %@, externalID: %@", self.title, self.year, self.tags, @(self.externalID)];
}

@end
