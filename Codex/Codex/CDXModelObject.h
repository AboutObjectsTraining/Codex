//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <Foundation/Foundation.h>

@class NSEntityDescription;
@class NSRelationshipDescription;

@interface CDXModelObject : NSObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary forEntity:(NSEntityDescription *)entity;


// The following methods can be overridden by subclasses,
// but your code shouldn't call them directly.

- (void)setAttributeValuesWithDictionary:(NSDictionary *)dictionary;
- (void)setRelationshipValuesWithDictionary:(NSDictionary *)dictionary;

- (NSArray *)toManyValueWithDictionaries:(NSArray *)dictionaries forRelationship:(NSRelationshipDescription *)relationship;
- (CDXModelObject *)toOneValueWithDictionary:(NSDictionary *)dictionary forRelationship:(NSRelationshipDescription *)relationship;


@end
