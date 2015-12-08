// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <Foundation/Foundation.h>

@class ELTBook;
@class ELTAuthor;

extern NSString *ELTDocumentPathForFileName(NSString *fileName);


@interface ELTObjectStore : NSObject

//+ (instancetype)storeWithModelName:(NSString *)modelName encodedValues:(NSArray *)dictionaries;

@property (readonly, nonatomic) NSArray *topLevelObjects;

- (NSArray *)valuesByEncodingAuthors;

- (void)invalidateCache;

- (NSString *)titleForSection:(NSInteger)section;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (ELTBook *)bookAtIndexPath:(NSIndexPath *)indexPath;

- (void)insertBook:(ELTBook *)book atIndexPath:(NSIndexPath *)indexPath;
- (void)removeBook:(ELTBook *)book atIndexPath:(NSIndexPath *)indexPath;

@end
