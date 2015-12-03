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

@property (nonatomic, assign) NSInteger externalID;

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, readonly) NSString *fullName;
@property (nullable, nonatomic, retain) NSArray<CDXBook *> *books;

@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSURL *imageURL;

@end


NS_ASSUME_NONNULL_END

