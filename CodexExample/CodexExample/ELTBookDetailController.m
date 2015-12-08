//
// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
#import "UIImage+ELTAdditions.h"
#import "ELTBookDetailController.h"

#import "ELTAuthor.h"
#import "ELTBook.h"

@interface ELTBookDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;

@end


@implementation ELTBookDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.titleLabel.text = self.book.title;
    self.yearLabel.text = self.book.year;
    self.bookImageView.image = [UIImage elt_imageForBook:self.book];
    
    self.firstNameLabel.text = self.book.author.firstName;
    self.lastNameLabel.text = self.book.author.lastName;
    self.authorImageView.image = [UIImage elt_imageForAuthor:self.book.author];
}

@end
