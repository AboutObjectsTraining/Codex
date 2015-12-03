//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import <Foundation/Foundation.h>

NSString *CDXTransformerNameForClass(Class targetType);
NSString *CDXTransformerNameForClassName(NSString *className);

void CDXRegisterValueTransformerClass(Class transformerClass);
