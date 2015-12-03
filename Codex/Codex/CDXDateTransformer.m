//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import "NSValueTransformer+CDXAdditions.h"
#import "CDXDateTransformer.h"

NSString * const CDXExternalDateFormat = @"yyyy-MM-dd";

@implementation CDXDateTransformer

+ (void)load
{
    CDXRegisterValueTransformerClass(self);
}

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (NSDateFormatter *)externalDateFormatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = CDXExternalDateFormat;
    });
    return formatter;
}

+ (NSDateFormatter *)presentationDateFormatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });
    return formatter;
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

// Encode
- (id)transformedValue:(id)value
{
    return value == nil ? nil : [[self.class presentationDateFormatter] stringFromDate:value];
}

// Decode
- (id)reverseTransformedValue:(id)value
{
    return value == nil ? nil : [[self.class externalDateFormatter] dateFromString:value];
}

@end
