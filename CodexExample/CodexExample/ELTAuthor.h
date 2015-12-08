//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Codex/Codex.h>

@class ELTBook;

NS_ASSUME_NONNULL_BEGIN

@interface ELTAuthor : CDXModelObject

+ (NSString *)entityName;
@property (nonatomic, assign) NSInteger externalID;

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, readonly) NSString *fullName;

@property (nullable, nonatomic, retain) NSArray<ELTBook *> *books;
- (void)insertBook:(ELTBook *)book atIndex:(NSUInteger)index;
- (void)removeBookAtIndex:(NSUInteger)index;

@property (nullable, nonatomic, retain) NSDate *dateOfBirth;
@property (nullable, nonatomic, retain) NSURL *imageURL;

@end


// Property keys

extern const struct ELTAuthorAttributes {
    NSString *  __unsafe_unretained externalID;
    NSString * __unsafe_unretained firstName;
    NSString * __unsafe_unretained lastName;
    NSString * __unsafe_unretained dateOfBirth;
    NSString * __unsafe_unretained imageURL;
} ELTAuthorAttributes;


extern const struct ELTAuthorRelationships {
    NSString * __unsafe_unretained books;
} ELTAuthorRelationships;


NS_ASSUME_NONNULL_END


