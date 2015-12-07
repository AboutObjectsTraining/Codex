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
@property (strong, nonatomic) NSDictionary *responseDict;
@property (strong, nonatomic) NSArray *authorDicts;
@end

@implementation ExampleModelTests

- (void)setUp {
    [super setUp];
    
    NSURL *plistURL = [[NSBundle bundleForClass:self.class] URLForResource:@"Authors_v2" withExtension:@"plist"];
    self.responseDict = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    self.authorDicts = self.responseDict[@"authors"];
    XCTAssertNotNil(self.authorDicts);
    
    NSURL *momdURL = [[NSBundle bundleForClass:self.class] URLForResource:@"Authors" withExtension:@"momd"];
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
    CDXBook *book = [CDXBook modelObjectWithDictionary:bookDict entity:authorEntity];
    NSLog(@"%@", book);
    XCTAssertEqualObjects(book.title, bookDict[@"title"]);
}

- (void)testPopulateAuthor
{
    NSDictionary *authorDict = self.authorDicts[0];
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    CDXAuthor *author = [CDXAuthor modelObjectWithDictionary:authorDict entity:authorEntity];
    NSLog(@"%@", author);
    XCTAssertEqualObjects(author.lastName, authorDict[@"lastName"]);
    
    NSArray *bookDicts = authorDict[@"books"];
    XCTAssertEqual(author.books.count, bookDicts.count);
    XCTAssertEqualObjects([author.books[0] title], bookDicts[0][@"title"]);
}

- (void)testValueTransformersAndExternalKeypaths
{
    NSDictionary *dict = self.authorDicts[0];
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    CDXAuthor *author = [CDXAuthor modelObjectWithDictionary:dict entity:authorEntity];
    NSLog(@"%@", author);

    XCTAssertTrue([author.imageURL isKindOfClass:[NSURL class]]);
    XCTAssertTrue([author.dateOfBirth isKindOfClass:[NSDate class]]);
    XCTAssertTrue([[author.books[0] tags] isKindOfClass:[NSArray class]]);
    
    NSDictionary *authorDict = author.dictionaryRepresentation;
    NSLog(@"%@", authorDict);
    XCTAssertTrue([authorDict[@"imageURL"] isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects([authorDict[@"author_id"] description], self.authorDicts[0][@"author_id"]);
    XCTAssertEqualObjects(authorDict[@"born"], self.authorDicts[0][@"born"]);
    
    NSDictionary *bookDict = authorDict[@"books"][0];
    XCTAssertEqualObjects([bookDict[@"book_id"] description], self.authorDicts[0][@"books"][0][@"book_id"]);
    XCTAssertEqualObjects(bookDict[@"tags"], self.authorDicts[0][@"books"][0][@"tags"]);
}

- (void)testDictionaryRepresentationOfAuthor
{
    NSDictionary *authorDict = self.authorDicts[0];
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    CDXAuthor *author = [CDXAuthor modelObjectWithDictionary:authorDict entity:authorEntity];
    NSLog(@"%@", author);
    
    NSDictionary *dict = author.dictionaryRepresentation;
    NSLog(@"%@", dict);
    XCTAssertEqualObjects(authorDict[@"lastName"], author.lastName);
    
    NSArray *bookDicts = authorDict[@"books"];
    XCTAssertEqual(bookDicts.count, author.books.count);
    XCTAssertEqualObjects(bookDicts[0][@"title"], [author.books[0] title]);
}

- (void)testJSONRepresentationOfAuthor
{
    NSDictionary *authorDict = self.authorDicts[0];
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    CDXAuthor *author = [CDXAuthor modelObjectWithDictionary:authorDict entity:authorEntity];
    NSLog(@"%@", author);
    
    XCTAssertTrue([author.imageURL isKindOfClass:[NSURL class]]);
    XCTAssertTrue([author.dateOfBirth isKindOfClass:[NSDate class]]);
    XCTAssertTrue([[author.books[0] tags] isKindOfClass:[NSArray class]]);
    
    NSString *authorJSONString = author.JSONRepresentation;
    NSLog(@"%@", authorJSONString);
    
    NSData *authorData = [authorJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *authorJSONDict = [NSJSONSerialization JSONObjectWithData:authorData options:0 error:NULL];
    
    XCTAssertTrue([authorJSONDict[@"imageURL"] isKindOfClass:[NSString class]]);
    XCTAssertEqualObjects([authorJSONDict[@"author_id"] description], authorDict[@"author_id"]);
    XCTAssertEqualObjects(authorJSONDict[@"born"], self.authorDicts[0][@"born"]);
    
    NSDictionary *bookDict = authorDict[@"books"][0];
    NSDictionary *bookJSONDict = authorJSONDict[@"books"][0];
    XCTAssertEqualObjects([bookJSONDict[@"book_id"] description], bookDict[@"book_id"]);
    XCTAssertEqualObjects(bookJSONDict[@"tags"], bookDict[@"tags"]);
}

- (void)testAuthorFromJSON
{
    NSDictionary *authorDict = self.authorDicts[0];
    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"FirstAuthor_v2" withExtension:@"json"];
    NSString *authorJSONString = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:NULL];
    
    NSEntityDescription *authorEntity = self.model.entitiesByName[@"Author"];
    CDXAuthor *author = [CDXAuthor modelObjectWithJSONString:authorJSONString entity:authorEntity];
    NSLog(@"%@", author);
    XCTAssertEqualObjects(authorDict[@"author_id"], [@(author.externalID) description]);
    XCTAssertEqualObjects(authorDict[@"lastName"], author.lastName);
    
    NSDictionary *bookDict = authorDict[@"books"][0];
    CDXBook *book = author.books[0];
    XCTAssertEqualObjects(bookDict[@"book_id"], [@(book.externalID) description]);
    XCTAssertEqualObjects(bookDict[@"tags"], [book.tags componentsJoinedByString:@","]);
}

@end
