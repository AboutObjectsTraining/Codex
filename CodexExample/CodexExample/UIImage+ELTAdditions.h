//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <UIKit/UIKit.h>

@class CDXBook;
@class CDXAuthor;

@interface UIImage (ELTAdditions)

+ (UIImage *)elt_imageForBook:(CDXBook *)book;
+ (UIImage *)elt_imageForAuthor:(CDXAuthor *)author;

+ (UIImage *)elt_imageNamed:(NSString *)imageName alternateImageName:(NSString *)alternateImageName;

@end
