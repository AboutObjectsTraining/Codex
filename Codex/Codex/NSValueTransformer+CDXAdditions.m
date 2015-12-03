//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "NSValueTransformer+CDXAdditions.h"

void CDXRegisterValueTransformerClass(Class transformerClass)
{
    NSString *name = CDXTransformerNameForClass([transformerClass transformedValueClass]);
    
    if ([transformerClass valueTransformerForName:name] == nil) {
        [transformerClass setValueTransformer:[[transformerClass alloc] init] forName:name];
    }
}

NSString *CDXTransformerNameForClass(Class targetType)
{
    NSString *targetClassName = NSStringFromClass(targetType);
    if ([targetClassName hasPrefix:@"NS"]) {
        targetClassName = [targetClassName substringFromIndex:2];
    }
    return [NSString stringWithFormat:@"CDX%@Transformer", targetClassName];
}

NSString *CDXTransformerNameForClassName(NSString *className)
{
    return CDXTransformerNameForClass(NSClassFromString(className));
}


@implementation NSValueTransformer (CDXAdditions)

+ (NSValueTransformer *)cdx_valueTransformerForAttribute:(NSAttributeDescription *)attribute
{
    NSValueTransformer *transformer = [self valueTransformerForName:attribute.valueTransformerName];
    
    return (transformer ? transformer :
            [self cdx_valueTransformerForClassName:attribute.entity.managedObjectClassName]);
}

+ (NSValueTransformer *)cdx_valueTransformerForClassName:(NSString *)className
{
    return [self valueTransformerForName:CDXTransformerNameForClassName(className)];
}

@end
