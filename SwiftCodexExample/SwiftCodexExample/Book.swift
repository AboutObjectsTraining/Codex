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
    
    public var favorite: Bool?
    var kvc_favorite: Bool {
        get { return favorite ?? false }
        set { favorite = Optional(newValue) }
    }
    
    // TODO: Add to xcmodel
    //
    public var rating: Int?
    var kvc_rating: Int {
        get { return rating ?? 0 }
        set { rating = Optional(newValue) }
    }
    
    public var year: String?
    public var tags: [String]?
    
    public var author: Author?
    
    
    // TODO: Automate UI transformations
    
    public var transformedTags: String? {
        get {
            return tagsTransformer?.transformedValue(tags) as? String
        }
        set {
            self.tags = tagsTransformer?.reverseTransformedValue(newValue) as? [String]
        }
    }
    
    var tagsTransformer: NSValueTransformer? =  {
        return NSValueTransformer(forName: CommaSeparatedValuesTransformer.TransformerName)
    }()
    
    override public var description: String {
        return "\(super.description) title: \(title); year: \(year), tags: \(tags), externalID: \(externalID)"
    }
}
