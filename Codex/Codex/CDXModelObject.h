//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <Foundation/Foundation.h>

@class NSEntityDescription;
@class NSRelationshipDescription;

@interface CDXModelObject : NSObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary forEntity:(NSEntityDescription *)entity;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary forRelationship:(NSRelationshipDescription *)relationship;


// The following methods can be overridden by subclasses,
// but your code shouldn't call them directly.

- (void)setAttributeValuesForKeysWithDictionary:(NSDictionary *)dictionary;
- (void)setRelationshipValuesForKeysWithDictionary:(NSDictionary *)dictionary;

- (void)setBothSidesOfRelationship:(NSRelationshipDescription *)relationship withValuesFromDictionaries:(NSArray *)dictionaries;
- (void)setBothSidesOfRelationship:(NSRelationshipDescription *)relationship withValuesFromDictionary:(NSDictionary *)dictionary;


@end
