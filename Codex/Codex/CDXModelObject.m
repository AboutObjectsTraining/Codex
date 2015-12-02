//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <CoreData/CoreData.h>
#import "NSArray+CDXAdditions.h"
#import "NSPropertyDescription+CDXAdditions.h"
#import "CDXModelObject.h"

@interface CDXModelObject ()

@property (strong, nonatomic) NSEntityDescription *entity;
@property (copy, nonatomic) NSDictionary *snapshot;

@property (readonly, nonatomic) NSDictionary *relationshipValues;
@property (readonly, nonatomic) NSDictionary *attributeValues;

@end


@implementation CDXModelObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary forRelationship:(NSRelationshipDescription *)relationship
{
    id value = [dictionary valueForKeyPath:relationship.cdx_externalKeyPath];
    
    return value = nil ? nil : [self modelObjectWithDictionary:value forEntity:relationship.entity];
}

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary forEntity:(NSEntityDescription *)entity
{
    Class class = NSClassFromString(entity.managedObjectClassName);
    CDXModelObject *modelObject = [[class alloc] init];
    modelObject.entity = entity;
    modelObject.snapshot = dictionary;
    
    [modelObject setAttributeValuesForKeysWithDictionary:dictionary];
    [modelObject setRelationshipValuesForKeysWithDictionary:dictionary];
    
    return modelObject;
}


- (void)setAttributeValuesForKeysWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in self.entity.attributesByName)
    {
        NSAttributeDescription *attribute = self.entity.attributesByName[key];
        id value = [dictionary valueForKeyPath:attribute.cdx_externalKeyPath];
        
        // TODO: Register value transformers
        
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:attribute.valueTransformerName];
        if (transformer != nil) {
            value = [transformer transformedValue:value];
        }
        
        [self setValue:value forKey:key];
    }
}

- (void)setRelationshipValuesForKeysWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in self.entity.relationshipsByName)
    {
        NSRelationshipDescription *relationship = self.entity.relationshipsByName[key];
        id value = [dictionary valueForKeyPath:relationship.cdx_externalKeyPath];
        
        // If there's no value corresponding to the external keypath, assume the
        // the relationship represents a back-pointer, in which case do nothing.
        if (value == nil) {
            return;
        }
        
        if (relationship.isToMany) {
            [self setBothSidesOfRelationship:relationship withValuesFromDictionaries:value];
        } else {
            [self setBothSidesOfRelationship:relationship withValuesFromDictionary:value];
        }
    }
}

- (void)setBothSidesOfRelationship:(NSRelationshipDescription *)relationship withValuesFromDictionaries:(NSArray *)dictionaries
{
    NSParameterAssert([dictionaries isKindOfClass:[NSArray class]]);
    
    NSMutableArray *modelObjs = [NSMutableArray arrayWithCapacity:dictionaries.count];
    for (NSDictionary *dict in dictionaries) {
        [modelObjs addObject:[CDXModelObject modelObjectWithDictionary:dict forEntity:relationship.destinationEntity]];
        if (relationship.inverseRelationship != nil) {
            [modelObjs.lastObject setValue:self forKey:relationship.inverseRelationship.name];
        }
    }
    [self setValue:modelObjs forKey:relationship.name];
}

- (void)setBothSidesOfRelationship:(NSRelationshipDescription *)relationship withValuesFromDictionary:(NSDictionary *)dictionary
{
    NSParameterAssert([dictionary isKindOfClass:[NSDictionary class]]);
    
    CDXModelObject *modelObj = [CDXModelObject modelObjectWithDictionary:dictionary forRelationship:relationship];
    if (relationship.inverseRelationship != nil) {
        [modelObj setValue:self forKey:relationship.inverseRelationship.name];
    }
    [self setValue:modelObj forKey:relationship.name];
}

- (NSDictionary *)relationshipValues
{
    NSDictionary *relationships = self.entity.relationshipsByName;
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithCapacity:relationships.count];
    
    NSDictionary *dict = [self dictionaryWithValuesForKeys:relationships.allKeys];
    for (NSString *key in dict) {
        id currVal = dict[key];
        if (currVal != [NSNull null]) {
            NSRelationshipDescription *relationship = relationships[key];
            if (relationship.isToMany) {
                values[key] = [currVal cdx_dictionaryRepresentation];
            }
            else if (relationship.inverseRelationship == nil) {
                values[key] = [currVal dictionaryRepresentation];
            }
        }
    }
    return values;
}

- (NSDictionary *)attributeValues
{
    NSDictionary *attributes = self.entity.attributesByName;
    NSMutableDictionary *values = [[self dictionaryWithValuesForKeys:attributes.allKeys] mutableCopy];
    [values removeObjectsForKeys:[values allKeysForObject:[NSNull null]]];
    
    for (NSString *key in attributes) {
        NSAttributeDescription *attribute = attributes[key];
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:attribute.valueTransformerName];
        if (transformer != nil && values[key] != nil) {
            values[key] = [transformer reverseTransformedValue:values[key]];
        }
    }
    return values;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRep = [self.attributeValues mutableCopy];
    [dictionaryRep addEntriesFromDictionary:self.relationshipValues];
    
    return dictionaryRep;
}





@end
