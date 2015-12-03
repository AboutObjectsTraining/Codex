//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import "CDXTransformerUtilities.h"
#import "CDXArrayTransformer.h"

@implementation CDXArrayTransformer

+ (void)load
{
    CDXRegisterValueTransformerClass(self);
}

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

// Encode
- (id)transformedValue:(id)value
{
    return value == nil ? nil : [value componentsJoinedByString:@","];
}

// Decode
- (id)reverseTransformedValue:(id)value
{
    return value == nil ? nil : [value componentsSeparatedByString:@","];
}

@end
