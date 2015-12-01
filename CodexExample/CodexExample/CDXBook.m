//
//  CDXBook.m
//  Codex
//
//  Created by Jonathan on 11/25/15.
//  Copyright © 2015 About Objects. All rights reserved.
//

#import "CDXBook.h"
//#import "CDXAuthor.h"

@implementation CDXBook

// Insert code here to add functionality to your managed object subclass

- (NSString *)description
{
    return [NSString stringWithFormat:@"title: %@; year: %@", self.title, self.year];
}

@end
