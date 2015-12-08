//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Codex/Codex.h>

@class CDXBook;

NS_ASSUME_NONNULL_BEGIN

@interface CDXAuthor : CDXModelObject

+ (NSString *)entityName;
@property (nonatomic, assign) NSInteger externalID;

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, readonly) NSString *fullName;

@property (nullable, nonatomic, retain) NSArray<CDXBook *> *books;
- (void)insertBook:(CDXBook *)book atIndex:(NSUInteger)index;
- (void)removeBookAtIndex:(NSUInteger)index;

@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSURL *imageURL;

@end


// Property keys

extern const struct CDXAuthorAttributes {
    NSString *  __unsafe_unretained externalID;
    NSString * __unsafe_unretained firstName;
    NSString * __unsafe_unretained lastName;
    NSString * __unsafe_unretained dateOfBirth;
    NSString * __unsafe_unretained imageURL;
} CDXAuthorAttributes;


extern const struct CDXAuthorRelationships {
    NSString * __unsafe_unretained books;
} CDXAuthorRelationships;


NS_ASSUME_NONNULL_END


