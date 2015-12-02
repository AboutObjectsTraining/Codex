//
//  ExampleModelTests.m
//  ExampleModelTests
//
//  Created by Jonathan on 11/24/15.
//  Copyright © 2015 About Objects. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <XCTest/XCTest.h>
#import <Codex/Codex.h>

#import "CDXBook.h"
#import "CDXAuthor.h"

@interface ExampleModelTests : XCTestCase
@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSArray *authorDicts;
@end

@implementation ExampleModelTests

- (void)setUp {
    [super setUp];
    
    NSURL *plistURL = [[NSBundle bundleForClass:self.class] URLForResource:@"Authors" withExtension:@"plist"];
    self.authorDicts = [NSArray arrayWithContentsOfURL:plistURL];
    XCTAssertNotNil(self.authorDicts);
    
    NSURL *momdURL = [[NSBundle bundleForClass:self.class] URLForResource:@"EnglishLiterature" withExtension:@"momd"];
    NSLog(@"%@", momdURL);
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
    XCTAssertNotNil(self.model);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testEntityDescriptions
{
    NSArray *entities = self.model.entities;
    for (NSEntityDescription *entity in entities) {
        NSLog(@"Attributes: %@", entity.attributesByName);
        NSLog(@"Relationships: %@", entity.relationshipsByName);
        NSLog(@"Class: %@", entity.managedObjectClassName);
    }
}

- (void)testAttributes
{
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    NSAttributeDescription *firstNameAttribute = authorEntity.attributesByName[@"firstName"];
    
    NSLog(@"%@", firstNameAttribute);
    NSLog(@"Name: %@", firstNameAttribute.name);
    NSLog(@"Type: %ld", firstNameAttribute.attributeType);
    NSLog(@"Transformer: %@", firstNameAttribute.valueTransformerName);
    NSLog(@"Hash: %@", firstNameAttribute.versionHash);
}

- (void)testPopulateBook
{
    NSDictionary *authorDict = self.authorDicts[0];
    NSDictionary *bookDict = authorDict[@"books"][0];
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Book"];
    CDXBook *book = [CDXBook modelObjectWithDictionary:bookDict forEntity:authorEntity];
    NSLog(@"%@", book);
    XCTAssertEqualObjects(book.title, bookDict[@"title"]);
}

- (void)testPopulateAuthor
{
    NSDictionary *authorDict = self.authorDicts[0];
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    CDXAuthor *author = [CDXAuthor modelObjectWithDictionary:authorDict forEntity:authorEntity];
    NSLog(@"%@", author);
    XCTAssertEqualObjects(author.lastName, authorDict[@"lastName"]);
    NSArray *bookDicts = authorDict[@"books"];
    XCTAssertEqual(author.books.count, bookDicts.count);
    XCTAssertEqualObjects([author.books[0] title], bookDicts[0][@"title"]);
}

- (void)testValueTransformers
{
    
}

- (void)testDictionaryRepresentationOfAuthor
{
    NSDictionary *authorDict = self.authorDicts[0];
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    CDXAuthor *author = [CDXAuthor modelObjectWithDictionary:authorDict forEntity:authorEntity];
    NSLog(@"%@", author);
    
    NSDictionary *dict = author.dictionaryRepresentation;
    NSLog(@"%@", dict);
}

@end
