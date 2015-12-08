//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import "UIColor+ELTColorScheme.h"

@implementation UIColor (ELTColorScheme)

+ (UIColor *)elt_oddRowColor
{
    return [UIColor colorWithRed:1.0 green:0.99 blue:0.97 alpha:1.0];
}

+ (UIColor *)elt_evenRowColor
{
    return [UIColor colorWithRed:0.98 green:0.96 blue:0.93 alpha:1.0];
}

+ (UIColor *)elt_headerColor
{
    return [UIColor colorWithRed:0.93 green:0.91 blue:0.87 alpha:1.0];
}

@end
