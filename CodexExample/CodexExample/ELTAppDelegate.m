//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import "ELTAppDelegate.h"
#import "UIColor+ELTColorScheme.h"

@implementation ELTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureAppearance];
    
    return YES;
}

- (void)configureAppearance
{
    [UITableView appearance].backgroundColor = [UIColor elt_headerColor];
    [UITableViewCell appearance].backgroundColor = [UIColor elt_oddRowColor];
}

@end
