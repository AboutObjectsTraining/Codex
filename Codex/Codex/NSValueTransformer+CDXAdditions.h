//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import <CoreData/CoreData.h>

extern void CDXRegisterValueTransformerClass(Class transformerClass);
extern NSString *CDXTransformerNameForClass(Class targetType);


@interface NSValueTransformer (CDXAdditions)

+ (NSValueTransformer *)cdx_valueTransformerForAttribute:(NSAttributeDescription *)attribute;

@end
