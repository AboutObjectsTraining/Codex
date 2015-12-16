//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import Foundation
import CoreData


extension NSPropertyDescription
{
    public var externalKeyPath: String {
        return userInfo?["externalKeyPath"] as? String ?? name
    }
}

extension NSArray
{
    public var dictionaryRepresentation: [[String: AnyObject]] {
        var dicts: [[String: AnyObject]] = []
            for currObj in self {
                if let modelObj = currObj as? ModelObject {
                    dicts.append(modelObj.dictionaryRepresentation)
                }
            }
        return dicts
    }
}

//extension NSValueTransformer
//{
//    public static func valueTransformerForAttribute(attribute: NSAttributeDescription)
//    {
//        
//    }
//}

public class ModelObject : NSObject
{
    var entity: NSEntityDescription!
    
    public required init(dictionary: [String: AnyObject], entity: NSEntityDescription)
    {
        self.entity = entity
        super.init()
        setAttributeValuesByDeserializing(dictionary)
        setRelationshipValuesByDeserializing(dictionary)
    }
}

// MARK: - Serializing

extension ModelObject
{
    public var dictionaryRepresentation: [String: AnyObject] {
        var dict = attributeValues
        for (key, value) in relationshipValues {
            dict[key] = value
        }
        return dict
    }
    
    // TODO: Add exception handling. Consider adding custom KVC methods that throw.
    // Probably need to construct intervening dictionaries, as needed.
    //
    public var attributeValues: [String: AnyObject] {
        get {
            return serializedAttributeValues
        }
        set {
            setAttributeValuesByDeserializing(newValue)
        }
    }
    
    public var relationshipValues: [String: AnyObject] {
        get {
            return serializedRelationshipValues
        }
        set {
            setRelationshipValuesByDeserializing(newValue)
        }
    }
    
    var serializedAttributeValues: [String: AnyObject] {
        let serializedVals: NSMutableDictionary = NSMutableDictionary()
        for (_, attribute) in entity.attributesByName {
            let val = serializedValue(forAttribute: attribute)
            serializedVals.setValue(val, forKeyPath: attribute.externalKeyPath)
        }
        return serializedVals.copy() as! [String: AnyObject]
    }
    
    var serializedRelationshipValues: [String: AnyObject] {
        let serializedVals: NSMutableDictionary = NSMutableDictionary()
        for (_, relationship) in entity.relationshipsByName {
            let val = serializedValue(forRelationship: relationship)
            serializedVals.setValue(val, forKeyPath: relationship.externalKeyPath)
        }
        return serializedVals.copy() as! [String: AnyObject]
    }
    
    func serializedValue(forAttribute attribute: NSAttributeDescription) -> AnyObject
    {
        var value = valueForKey(attribute.name)
        if value != nil,
            let transformerName = attribute.valueTransformerName,
            let transformer = NSValueTransformer(forName: transformerName) {
                value = transformer.transformedValue(value)
        }
        return value ?? NSNull()
    }
    
    func serializedValue(forRelationship relationship: NSRelationshipDescription) -> AnyObject
    {
        guard let value = valueForKey(relationship.name) where value !== NSNull() else {
            return NSNull()
        }
        
        if let modelObjs = value as? NSArray where relationship.toMany {
            return modelObjs.dictionaryRepresentation
        }
        else if let obj = value as? ModelObject where relationship.inverseRelationship != nil {
            return obj.dictionaryRepresentation
        }
        
        return NSNull()
    }
}

// MARK: - Deserializing

extension ModelObject
{
    public override func setValue(value: AnyObject?, forKey key: String)
    {
        let val = (value === NSNull() ? nil : value)
        super.setValue(val, forKey: key)
    }
    
    public func setAttributeValuesByDeserializing(dictionary: [String: AnyObject])
    {
        for (_, attribute) in entity.attributesByName {
            let val = (dictionary as NSDictionary).valueForKeyPath(attribute.externalKeyPath)
            deserialize(val, forAttribute: attribute)
        }
    }
    
    public func setRelationshipValuesByDeserializing(dictionary: [String: AnyObject])
    {
        for (_, relationship) in entity.relationshipsByName {
            if let val = (dictionary as NSDictionary).valueForKeyPath(relationship.externalKeyPath) {
                if let dicts = val as? [[String: AnyObject]] where relationship.toMany {
                    setBothSidesOfRelationship(relationship, withValuesFromDictionaries: dicts)
                }
                else if let dict = val as? [String: AnyObject] {
                    setBothSidesOfRelationship(relationship, withValuesFromDictionary: dict)
                }
            }
        }
    }

    func deserialize(var value: AnyObject?, forAttribute attribute: NSAttributeDescription)
    {
        if let val = value where val !== NSNull(),
            let transformerName = attribute.valueTransformerName,
            let transformer = NSValueTransformer(forName: transformerName) where
            transformer.dynamicType.allowsReverseTransformation() {
                value = transformer.reverseTransformedValue(val) ?? NSNull()
        }
        setValue(value, forKey: attribute.name)
    }
    
    
    public func setBothSidesOfRelationship(relationship: NSRelationshipDescription, withValuesFromDictionaries dictionaries: [[String: AnyObject]])
    {
        let modelObjects = dictionaries.map { (dict) -> ModelObject in
            let modelObj = self.dynamicType.init(dictionary: dict, entity: self.entity)
            if let key = relationship.inverseRelationship?.name {
                modelObj.setValue(self, forKey: key)
            }
            return modelObj
        }
        setValue(modelObjects, forKey: relationship.name)
    }
    
    public func setBothSidesOfRelationship(relationship: NSRelationshipDescription, withValuesFromDictionary dictionary: [String: AnyObject])
    {
        guard let dict = (dictionary as NSDictionary).valueForKeyPath(relationship.externalKeyPath) as? [String: AnyObject] else {
            return
        }
        
        let modelObj = self.dynamicType.init(dictionary: dict, entity: entity)
        if let key = relationship.inverseRelationship?.name {
            modelObj.setValue(self, forKey: key)
        }
        setValue(modelObj, forKey: relationship.name)
    }
}