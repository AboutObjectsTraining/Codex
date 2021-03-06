//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

@objc (CDXDateTransformer)
public class DateTransformer: NSValueTransformer
{
    public static let TransformerName = "CDXDate"
    public static let SerializedDateFormat = "yyyy-MM-dd"
    
    public static let serializedDateFormatter: NSDateFormatter = {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = SerializedDateFormat
        return formatter
    }()
    
    override public class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return true;
    }
    
    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let date = value as? NSDate else { return nil }
        return DateTransformer.serializedDateFormatter.stringFromDate(date)
    }
    
    public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        guard let stringVal = value as? String else { return nil }
        return DateTransformer.serializedDateFormatter.dateFromString(stringVal)
    }
}
