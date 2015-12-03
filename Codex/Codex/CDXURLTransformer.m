//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "NSValueTransformer+CDXAdditions.h"
#import "CDXURLTransformer.h"

@implementation CDXURLTransformer

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
    return value == nil ? nil : ((NSURL *)value).absoluteString;
}

// Decode
- (id)reverseTransformedValue:(id)value
{
    return value == nil ? nil : [NSURL URLWithString:value];
}

@end
