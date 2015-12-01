//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <CoreData/CoreData.h>
#import "NSPropertyDescription+CDXAdditions.h"
#import "CDXModelObject.h"

@interface CDXModelObject ()

@property (strong, nonatomic) NSEntityDescription *entity;
@property (copy, nonatomic) NSDictionary *snapshot;

@end


@implementation CDXModelObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary forRelationship:(NSRelationshipDescription *)relationship
{
    id value = [dictionary valueForKeyPath:relationship.externalKeyPath];
    
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
        id value = [dictionary valueForKeyPath:attribute.externalKeyPath];
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
        id value = [dictionary valueForKeyPath:relationship.externalKeyPath];
        
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
    for (NSDictionary *dict in dictionaries)
    {
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
