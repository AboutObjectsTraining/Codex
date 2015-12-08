//
//  CDXAuthor.m
//  Codex
//
//  Created by Jonathan on 11/25/15.
//  Copyright © 2015 About Objects. All rights reserved.
//

#import "CDXAuthor.h"

@interface CDXAuthor ()
@property (weak, readonly, nonatomic) NSMutableArray *mutableBooks;
@end

@implementation CDXAuthor

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
            @"lastName: %@, firstName: %@\nbooks:\n%@",
            self.lastName, self.firstName, self.books];
}

- (NSMutableArray *)mutableBooks
{
    return [self mutableArrayValueForKey:@"books"];
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
