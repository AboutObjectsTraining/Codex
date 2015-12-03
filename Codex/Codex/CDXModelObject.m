//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <CoreData/CoreData.h>
#import "NSArray+CDXAdditions.h"
#import "NSPropertyDescription+CDXAdditions.h"
#import "NSValueTransformer+CDXAdditions.h"
#import "CDXModelObject.h"

@interface CDXModelObject ()

@property (strong, readwrite, nonatomic) NSEntityDescription *entity;
@property (copy, readwrite, nonatomic) NSDictionary *snapshot; // TODO: Implement `revert` method

@end


@implementation CDXModelObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary entity:(NSEntityDescription *)entity
{
    Class class = NSClassFromString(entity.managedObjectClassName);
    CDXModelObject *modelObject = [[class alloc] init];
    if (modelObject == nil) {
        return nil;
    }
    
    modelObject.entity = entity;
    modelObject.snapshot = dictionary;
    
    [modelObject setAttributeValuesForKeysWithDictionary:dictionary];
    [modelObject setRelationshipValuesForKeysWithDictionary:dictionary];
    
    return modelObject;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRep = [self.attributeValues mutableCopy];
    [dictionaryRep addEntriesFromDictionary:self.relationshipValues];
    
    return dictionaryRep;
}

@end


@implementation CDXModelObject (Encoding)

- (NSDictionary *)attributeValues
{
    NSDictionary *attributes = self.entity.attributesByName;
    NSMutableDictionary *values = [[self dictionaryWithValuesForKeys:attributes.allKeys] mutableCopy];
    [values removeObjectsForKeys:[values allKeysForObject:[NSNull null]]];
    
    for (NSString *key in attributes)
    {
        NSAttributeDescription *attribute = attributes[key];
        NSValueTransformer *transformer = [NSValueTransformer cdx_valueTransformerForAttribute:attribute];
        if (transformer != nil && values[key] != nil && [transformer.class allowsReverseTransformation]) {
            values[key] = [transformer reverseTransformedValue:values[key]];
        }
    }
    return values;
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

@end


@implementation CDXModelObject (Decoding)

- (void)setAttributeValuesForKeysWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in self.entity.attributesByName)
    {
        NSAttributeDescription *attribute = self.entity.attributesByName[key];
        // TODO: Test external keypath
        id value = [dictionary valueForKeyPath:attribute.cdx_externalKeyPath];
        
        // TODO: Test value transformer registered in user dictionary
        NSValueTransformer *transformer = [NSValueTransformer cdx_valueTransformerForAttribute:attribute];
        value = transformer == nil ? value : [transformer transformedValue:value];
        
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
    
    NSMutableArray *modelObjects = [NSMutableArray arrayWithCapacity:dictionaries.count];
    for (NSDictionary *dict in dictionaries) {
        id modelObj = [self.class modelObjectWithDictionary:dict entity:relationship.destinationEntity];
        [modelObjects addObject:modelObj];
        if (relationship.inverseRelationship != nil) {
            [modelObj setValue:self forKey:relationship.inverseRelationship.name];
        }
    }
    [self setValue:modelObjects forKey:relationship.name];
}

- (void)setBothSidesOfRelationship:(NSRelationshipDescription *)relationship withValuesFromDictionary:(NSDictionary *)dictionary
{
    NSParameterAssert([dictionary isKindOfClass:[NSDictionary class]]);
    
    NSDictionary *dict = [dictionary valueForKeyPath:relationship.cdx_externalKeyPath];
    id modelObj = (dict = nil ? nil :
                   [self.class modelObjectWithDictionary:dict entity:relationship.entity]);
    if (relationship.inverseRelationship != nil) {
        [modelObj setValue:self forKey:relationship.inverseRelationship.name];
    }
    [self setValue:modelObj forKey:relationship.name];
}

@end
