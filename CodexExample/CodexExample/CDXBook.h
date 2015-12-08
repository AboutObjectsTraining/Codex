//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Codex/Codex.h>

@class CDXAuthor;

NS_ASSUME_NONNULL_BEGIN

@interface CDXBook : CDXModelObject

+ (NSString *)entityName;
@property (nonatomic, assign) NSInteger externalID;

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *year;
@property (nullable, nonatomic, weak) CDXAuthor *author;

@property (nullable, nonatomic, retain) NSArray *tags;

@end


// Property keys

extern const struct CDXBookAttributes {
    NSString *  __unsafe_unretained externalID;
    NSString * __unsafe_unretained title;
    NSString * __unsafe_unretained year;
    NSString * __unsafe_unretained tags;
} CDXBookAttributes;


extern const struct CDXBookRelationships {
    NSString * __unsafe_unretained author;
} CDXBookRelationships;

NS_ASSUME_NONNULL_END

