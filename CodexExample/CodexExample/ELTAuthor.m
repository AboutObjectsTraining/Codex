//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "ELTAuthor.h"

// Property keys

const struct ELTAuthorAttributes ELTAuthorAttributes = {
    .externalID = @"externalID",
    .firstName = @"firstName",
    .lastName = @"lastName",
    .dateOfBirth = @"dateOfBirth",
    .imageURL = @"imageURL",
};

const struct ELTAuthorRelationships ELTAuthorRelationships = {
    .books = @"books",
};



@interface ELTAuthor ()
@property (weak, readonly, nonatomic) NSMutableArray *mutableBooks;
@end

@implementation ELTAuthor

+ (NSString *)entityName { return @"Author"; }

- (NSString *)fullName
{
    return (self.lastName == nil && self.firstName == nil ? nil :
            self.firstName == nil ? self.lastName :
            self.lastName == nil ? self.firstName :
            [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName]);
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
    return [self mutableArrayValueForKey:ELTAuthorRelationships.books];
}

- (void)insertBook:(ELTBook *)book atIndex:(NSUInteger)index
{
    [self.mutableBooks insertObject:book atIndex:index];
}

- (void)removeBookAtIndex:(NSUInteger)index
{
    [self.mutableBooks removeObjectAtIndex:index];
}

@end
