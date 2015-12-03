//
//  CDXBook.h
//  Codex
//
//  Created by Jonathan on 11/25/15.
//  Copyright © 2015 About Objects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Codex/Codex.h>

@class CDXAuthor;

NS_ASSUME_NONNULL_BEGIN

@interface CDXBook : CDXModelObject

@property (nonatomic, assign) NSInteger externalID;

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *year;
@property (nullable, nonatomic, weak) CDXAuthor *author;

@property (nullable, nonatomic, retain) NSString *tags;

@end

NS_ASSUME_NONNULL_END

