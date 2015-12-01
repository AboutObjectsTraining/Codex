//
//  CDXAuthor.h
//  Codex
//
//  Created by Jonathan on 11/25/15.
//  Copyright © 2015 About Objects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Codex/Codex.h>

@class CDXBook;

NS_ASSUME_NONNULL_BEGIN

@interface CDXAuthor : CDXModelObject

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, readonly) NSString *fullName;
@property (nullable, nonatomic, retain) NSOrderedSet<CDXBook *> *books;

@end


NS_ASSUME_NONNULL_END

