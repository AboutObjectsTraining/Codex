//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

import Foundation
import SwiftCodex

@objc (CDXBook)
public class Book: ModelObject
{
    public static let entityName = "Book"
    
    public var externalID: NSNumber!
    public var title: String!
    
    public var year: String?
    public var tags: [String]?
    
    public var author: Author?
    
    public var transformedTags: String? {
        get {
            guard
                let transformer = NSValueTransformer(forName: CommaSeparatedValuesTransformer.TransformerName),
                let tagsStr = transformer.transformedValue(tags) as? String else { return nil }
            return tagsStr
        }
        set {
            if  let transformer = NSValueTransformer(forName: CommaSeparatedValuesTransformer.TransformerName),
                let tags = transformer.reverseTransformedValue(newValue) as? [String] {
                    self.tags = tags
            }
        }
    }
    
    override public var description: String {
        return "\(super.description) title: \(title); year: \(year), tags: \(tags), externalID: \(externalID)"
    }
}
