//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <objc/runtime.h>
#import <CoreData/CoreData.h>

#import "NSPropertyDescription+CDXAdditions.h"
#import "CDXModelObject.h"

@interface CDXModelObject ()

@property (strong, nonatomic) NSEntityDescription *entity;
@property (copy, nonatomic) NSDictionary *snapshot;

@end


@implementation CDXModelObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary forEntity:(NSEntityDescription *)entity
{
    CDXModelObject *modelObject = [[self alloc] init];
    modelObject.entity = entity;
    modelObject.snapshot = dictionary;
    
    [modelObject setAttributeValuesWithDictionary:dictionary];
    [modelObject setRelationshipValuesWithDictionary:dictionary];
    
    return modelObject;
}


- (void)setAttributeValuesWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in self.entity.attributesByName)
    {
        NSAttributeDescription *attribute = self.entity.attributesByName[key];
        id value = [dictionary valueForKeyPath:attribute.externalKeyPath];
        // TODO: Register value transformers
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:attribute.valueTransformerName];
        if (transformer != nil) {
            value = [transformer transformedValue:value];
        }
        
        [self setValue:value forKey:key];
    }
}

- (void)setRelationshipValuesWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in self.entity.relationshipsByName)
    {
        NSRelationshipDescription *relationship = self.entity.relationshipsByName[key];
        id value = [dictionary valueForKeyPath:relationship.externalKeyPath];
        
        if (value != nil) // If value is nil, this is a back-pointer.
        {
            value = (relationship.isToMany ?
                     [self toManyValueWithDictionaries:value forRelationship:relationship] :
                     [self toOneValueWithDictionary:value forRelationship:relationship]);
        }
        
        [self setValue:value forKey:key];
    }
}

- (NSArray *)toManyValueWithDictionaries:(NSArray *)dictionaries forRelationship:(NSRelationshipDescription *)relationship
{
    NSParameterAssert([dictionaries isKindOfClass:[NSArray class]]);
    NSMutableArray *modelObjs = [NSMutableArray arrayWithCapacity:dictionaries.count];
    
    for (NSDictionary *dictionary in dictionaries)
    {
        id value = [dictionary valueForKeyPath:relationship.externalKeyPath];
        NSEntityDescription *entity = self.entity.managedObjectModel.entitiesByName[relationship.name];
        CDXModelObject *modelObj = [CDXModelObject modelObjectWithDictionary:value forEntity:entity];
        
        [modelObjs addObject:modelObj];
        if (relationship.inverseRelationship != nil) {
            [modelObj setValue:self forKey:relationship.inverseRelationship.name];
        }
    }
    
    return modelObjs;
}

- (CDXModelObject *)toOneValueWithDictionary:(NSDictionary *)dictionary forRelationship:(NSRelationshipDescription *)relationship
{
    NSParameterAssert([dictionary isKindOfClass:[NSDictionary class]]);
    id value = [dictionary valueForKeyPath:relationship.externalKeyPath];
    
    NSEntityDescription *entity = self.entity.managedObjectModel.entitiesByName[relationship.name];
    CDXModelObject *modelObj = [CDXModelObject modelObjectWithDictionary:value forEntity:entity];
    
    if (relationship.inverseRelationship != nil) {
        [modelObj setValue:self forKey:relationship.inverseRelationship.name];
    }
    
    return modelObj;
}

//// TODO: Migrate to a category on NSArray?
//- (NSArray *)dictionaryRepresentationForModelObjects:(NSArray *)modelObjects
//{
//    NSMutableArray *dictionaries = [NSMutableArray arrayWithCapacity:modelObjects.count];
//    for (CDXModelObject *currObj in modelObjects) {
//        [dictionaries addObject:currObj.dictionaryRepresentation];
//    }
//    return dictionaries;
//}
//
//- (NSDictionary *)dictionaryRepresentationForRelationshipKeys:(NSArray *)relationshipKeys
//{
//    NSDictionary *dict = [self dictionaryWithValuesForKeys:relationshipKeys];
//    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:dict.count];
//    
//    for (NSString *key in dict)
//    {
//        id value = dict[key];
//        // Note: add support for other collection types (e.g. NSSet) here, if desired.
//        if ([value isKindOfClass:[NSArray class]]) {
//            // To-many relationship
//            mutableDict[key] = [self dictionaryRepresentationForModelObjects:value];
//        }
//        else if (value != [NSNull null]) {
//            // To-one relationship
//            mutableDict[key] = [value dictionaryRepresentation];
//        }
//    }
//    
//    return mutableDict;
//}
//
//- (NSDictionary *)dictionaryRepresentationForAttributeKeys:(NSArray *)attributeKeys
//{
//    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:attributeKeys] mutableCopy];
//    
//    // NSNull doesn't support property list serialization, and entries with null values
//    // waste storage space, so it's best to remove them.
//    [dict removeObjectsForKeys:[dict allKeysForObject:[NSNull null]]];
//    
//    return dict;
//}
//
//- (NSDictionary *)dictionaryRepresentation
//{
//    NSDictionary *attributes = [self dictionaryRepresentationForAttributeKeys:
//                                [[self class] attributeKeys]];
//    NSDictionary *relationships = [self dictionaryRepresentationForRelationshipKeys:
//                                   [[self class] relationshipKeys]];
//    
//    NSMutableDictionary *mutableDict = [attributes mutableCopy];
//    [mutableDict addEntriesFromDictionary:relationships];
//    
//    return mutableDict;
//}
//
//
//- (NSDictionary *)dictionaryRepresentation
//{
//    NSMutableDictionary *dict = [[self dictionaryWithValuesForKeys:[self.class keys].allObjects] mutableCopy];
//    
//    // NSNull doesn't support property list serialization, and entries with null values
//    // waste storage space, so it's best to remove them.
//    [dict removeObjectsForKeys:[dict allKeysForObject:[NSNull null]]];
//    
//    return dict;
//}

@end
