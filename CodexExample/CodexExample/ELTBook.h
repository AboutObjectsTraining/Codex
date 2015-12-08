//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Codex/Codex.h>

@class ELTAuthor;

NS_ASSUME_NONNULL_BEGIN

@interface ELTBook : CDXModelObject

+ (NSString *)entityName;
@property (nonatomic, assign) NSInteger externalID;

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *year;
@property (nullable, nonatomic, weak) ELTAuthor *author;

@property (nullable, nonatomic, retain) NSArray *tags;

@end


// Property keys

extern const struct ELTBookAttributes {
    NSString *  __unsafe_unretained externalID;
    NSString * __unsafe_unretained title;
    NSString * __unsafe_unretained year;
    NSString * __unsafe_unretained tags;
} ELTBookAttributes;


extern const struct ELTBookRelationships {
    NSString * __unsafe_unretained author;
} ELTBookRelationships;

NS_ASSUME_NONNULL_END

