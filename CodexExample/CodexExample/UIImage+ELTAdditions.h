//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import <UIKit/UIKit.h>

@class ELTBook;
@class ELTAuthor;

@interface UIImage (ELTAdditions)

+ (UIImage *)elt_imageForBook:(ELTBook *)book;
+ (UIImage *)elt_imageForAuthor:(ELTAuthor *)author;

+ (UIImage *)elt_imageNamed:(NSString *)imageName alternateImageName:(NSString *)alternateImageName;

@end
