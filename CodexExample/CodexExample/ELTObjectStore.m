//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <UIKit/UIKit.h>
#import <Codex/Codex.h>
#import "ELTObjectStore.h"
#import "ELTAuthor.h"
#import "ELTBook.h"

NSString * const ELTModelName = @"Authors";
NSString * const ELTFileName = @"Authors_v2";

NSString *ELTDocumentPathForFileName(NSString *fileName)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths.firstObject stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"plist"];
}


@interface ELTObjectStore ()

@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSEntityDescription *entity;
@property (strong, nonatomic) NSMutableArray *authors;
@property (strong, nonatomic) NSArray *encodedValues;

@end


@implementation ELTObjectStore

- (NSManagedObjectModel *)model
{
    if (!_model) {
        NSURL *momdURL = [[NSBundle bundleForClass:self.class]
                          URLForResource:ELTModelName withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
    }
    return _model;
}

- (NSArray *)encodedValues
{
    if (_encodedValues == nil) {
        NSString *path = ELTDocumentPathForFileName(ELTFileName);
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict == nil) {
            path = [[NSBundle bundleForClass:self.class] pathForResource:ELTFileName ofType:@"plist"];
            dict = [NSDictionary dictionaryWithContentsOfFile:path];
            if (!dict) NSLog(@"*** WARNING: Unable to load file at path %@", path);
        }
        _encodedValues = dict[@"authors"];
    }
    return _encodedValues;
}

- (NSEntityDescription *)entity
{
    if (!_entity) {
        _entity = self.model.entitiesByName[[ELTAuthor entityName]];
    }
    return _entity;
}

- (NSArray *)topLevelObjects
{
    return self.authors;
}

- (NSMutableArray *)authors
{
    if (_authors == nil) {
        [self decodeAuthors];
    }
    return _authors;
}

- (void)decodeAuthors
{
    NSMutableArray *authors = [NSMutableArray arrayWithCapacity:self.encodedValues.count];
    for (NSDictionary *dict in self.encodedValues) {
        [authors addObject:[ELTAuthor modelObjectWithDictionary:dict entity:self.entity]];
    }
    
    self.authors = authors;
}

- (NSArray *)valuesByEncodingAuthors
{
    return [self.authors cdx_dictionaryRepresentation];
}

- (void)invalidateCache
{
    self.authors = nil;
}

- (NSString *)titleForSection:(NSInteger)section
{
    ELTAuthor *author = self.authors[section];
    return author.fullName;
}

- (NSInteger)numberOfSections
{
    return self.authors.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    ELTAuthor *author = self.authors[section];
    return author.books.count;
}

- (ELTBook *)bookAtIndexPath:(NSIndexPath *)indexPath
{
    ELTAuthor *author = self.authors[indexPath.section];
    return author.books[indexPath.row];
}

- (void)removeBook:(ELTBook *)book atIndexPath:(NSIndexPath *)indexPath
{
    ELTAuthor *author = self.authors[indexPath.section];
    [author removeBookAtIndex:indexPath.row];
}

- (void)insertBook:(ELTBook *)book atIndexPath:(NSIndexPath *)indexPath
{
    ELTAuthor *author = self.authors[indexPath.section];
    [author insertBook:book atIndex:indexPath.row];
}


@end
