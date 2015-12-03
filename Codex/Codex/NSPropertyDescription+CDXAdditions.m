//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import "NSPropertyDescription+CDXAdditions.h"

@implementation NSPropertyDescription (CDXAdditions)

- (NSString *)cdx_externalKeyPath
{
    NSString *keyPath = self.userInfo[@"externalKeyPath"];
    
    return keyPath ? keyPath : self.name;
}

@end
