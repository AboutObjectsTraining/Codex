//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "CDXAuthor.h"

// Property keys

const struct CDXAuthorAttributes CDXAuthorAttributes = {
    .externalID = @"externalID",
    .firstName = @"firstName",
    .lastName = @"lastName",
    .dateOfBirth = @"dateOfBirth",
    .imageURL = @"imageURL",
};

const struct CDXAuthorRelationships CDXAuthorRelationships = {
    .books = @"books",
};



@interface CDXAuthor ()
@property (weak, readonly, nonatomic) NSMutableArray *mutableBooks;
@end

@implementation CDXAuthor

+ (NSString *)entityName { return @"Author"; }

- (NSString *)fullName
{
    return (self.firstName && self.lastName ?
            [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName] :
            self.firstName ? self.firstName :
            self.lastName ? self.lastName : nil);
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"fullName: %@, dateOfBirth: %@\n"
            @"externalID: %@\n"
            @"imageURL: %@\n"
            @"books:\n%@",
            self.fullName, self.dateOfBirth,
            @(self.externalID),
            self.imageURL,
            self.books];
}

- (NSMutableArray *)mutableBooks
{
    return [self mutableArrayValueForKey:CDXAuthorRelationships.books];
}

- (void)insertBook:(CDXBook *)book atIndex:(NSUInteger)index
{
    [self.mutableBooks insertObject:book atIndex:index];
}

- (void)removeBookAtIndex:(NSUInteger)index
{
    [self.mutableBooks removeObjectAtIndex:index];
}

@end
