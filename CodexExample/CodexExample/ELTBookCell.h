//
//  ELTBookCell.h
//  EnglishLit
//
//  Created by Jonathan on 11/20/15.
//  Copyright © 2015 About Objects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELTBookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

@end
