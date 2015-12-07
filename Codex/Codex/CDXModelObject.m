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
// TODO: not currently used, but in future could support hasChanges, revert, etc.
@property (copy, readwrite, nonatomic) NSDictionary *snapshot;

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

+ (instancetype)modelObjectWithJSONString:(NSString *)JSONString entity:(NSEntityDescription *)entity
{
    NSData *data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    return [self modelObjectWithDictionary:dict entity:entity];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRep = [self.attributeValues mutableCopy];
    [dictionaryRep addEntriesFromDictionary:self.relationshipValues];
    
    return dictionaryRep;
}

// TODO: Migrate to store controller
- (NSString *)JSONRepresentation
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionaryRepresentation
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end


@implementation CDXModelObject (Encoding)

- (NSDictionary *)attributeValues
{
    NSDictionary *attributes = self.entity.attributesByName;
    NSDictionary *outboundVals = [self dictionaryWithValuesForKeys:attributes.allKeys];
    NSMutableDictionary *attributeVals = [NSMutableDictionary dictionary];
    
    for (NSAttributeDescription *attribute in attributes.allValues) {
        NSValueTransformer *transformer = [NSValueTransformer cdx_valueTransformerForAttribute:attribute];
        id value = [outboundVals valueForKeyPath:attribute.name];
        value = transformer == nil ? value : [transformer transformedValue:value];
        
        // TODO: Construct intervening objects if they don't exist yet.
        [attributeVals setValue:value forKeyPath:attribute.cdx_keyPath];
    }
    return attributeVals;
}


- (NSDictionary *)relationshipValues
{
    NSDictionary *relationships = self.entity.relationshipsByName;
    NSDictionary *outboundVals = [self dictionaryWithValuesForKeys:relationships.allKeys];
    NSMutableDictionary *relationshipVals = [NSMutableDictionary dictionary];
    
    for (NSRelationshipDescription *relationship in relationships.allValues) {
        id val = outboundVals[relationship.name];
        if (val != [NSNull null]) {
            if (relationship.isToMany) {
                relationshipVals[relationship.cdx_keyPath] = [val cdx_dictionaryRepresentation];
            }
            else if (relationship.inverseRelationship == nil) {
                relationshipVals[relationship.cdx_keyPath] = [val dictionaryRepresentation];
            }
        }
    }
    return relationshipVals;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    value = (value == [NSNull null] ? nil : value);
    
    [super setValue:value forKey:key];
}

@end


@implementation CDXModelObject (Decoding)

- (void)setAttributeValuesForKeysWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *attributes = self.entity.attributesByName;
    
    for (NSString *key in attributes)
    {
        NSAttributeDescription *attribute = attributes[key];
        id value = [dictionary valueForKeyPath:attribute.cdx_keyPath];
        
        NSValueTransformer *transformer = [NSValueTransformer cdx_valueTransformerForAttribute:attribute];
        if (transformer != nil && [transformer.class allowsReverseTransformation]) {
            value = [transformer reverseTransformedValue:value];
        }
        
        [self setValue:value forKey:key];
    }
}

- (void)setRelationshipValuesForKeysWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *relationships = self.entity.relationshipsByName;

    for (NSString *key in relationships)
    {
        NSRelationshipDescription *relationship = relationships[key];
        id value = [dictionary valueForKeyPath:relationship.cdx_keyPath];
        
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
    
    NSMutableArray *modelObjects = [NSMutableArray array];
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
    
    NSDictionary *dict = [dictionary valueForKeyPath:relationship.cdx_keyPath];
    id modelObj = (dict = nil ? nil :
                   [self.class modelObjectWithDictionary:dict entity:relationship.entity]);
    if (relationship.inverseRelationship != nil) {
        [modelObj setValue:self forKey:relationship.inverseRelationship.name];
    }
    [self setValue:modelObj forKey:relationship.name];
}

@end
