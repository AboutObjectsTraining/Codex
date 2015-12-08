//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import "CDXBook.h"
#import "CDXAuthor.h"
#import "UIImage+ELTAdditions.h"

@implementation UIImage (ELTAdditions)

+ (UIImage *)elt_imageForAuthor:(CDXAuthor *)author
{
    NSString *imageName = author.lastName;
    return [self elt_imageNamed:imageName alternateImageName:@"NoImage"];
}

+ (UIImage *)elt_imageForBook:(CDXBook *)book
{
    NSString *imageName = [book.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [self elt_imageNamed:imageName alternateImageName:@"DefaultImage"];
}

+ (UIImage *)elt_imageNamed:(NSString *)imageName alternateImageName:(NSString *)alternateImageName
{
    UIImage *image = [self imageNamed:imageName];
    return image ? image : [self imageNamed:alternateImageName];
}

@end
