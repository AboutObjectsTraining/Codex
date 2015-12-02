//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <Foundation/Foundation.h>

@class NSEntityDescription;
@class NSRelationshipDescription;

@interface CDXModelObject : NSObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary entity:(NSEntityDescription *)entity;
@property (readonly, nonatomic) NSDictionary *dictionaryRepresentation;

@property (strong, readonly, nonatomic) NSEntityDescription *entity;
@property (copy, readonly, nonatomic) NSDictionary *snapshot;

@end

// The following properties and methods can be overridden by subclasses,
// but your code shouldn't need to call them directly.

@interface CDXModelObject (Encoding)

@property (readonly, nonatomic) NSDictionary *relationshipValues;
@property (readonly, nonatomic) NSDictionary *attributeValues;

@end

@interface CDXModelObject (Decoding)

- (void)setAttributeValuesForKeysWithDictionary:(NSDictionary *)dictionary;
- (void)setRelationshipValuesForKeysWithDictionary:(NSDictionary *)dictionary;

- (void)setBothSidesOfRelationship:(NSRelationshipDescription *)relationship withValuesFromDictionaries:(NSArray *)dictionaries;
- (void)setBothSidesOfRelationship:(NSRelationshipDescription *)relationship withValuesFromDictionary:(NSDictionary *)dictionary;


@end
