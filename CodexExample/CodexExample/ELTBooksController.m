//
//  BookListViewController.m
//  Books
//
//  Created by Jonathan on 11/11/15.
//  Copyright © 2015 About Objects. All rights reserved.
//
#import "UIColor+ELTColorScheme.h"
#import "ELTBooksController.h"
#import "ELTBookDetailController.h"
#import "ELTDataSource.h"

@implementation ELTBooksController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ELTBookDetailController *controller = segue.destinationViewController;
    ELTBook *book = [self.dataSource objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    controller.book = book;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor elt_oddRowColor] : [UIColor elt_evenRowColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    [(id)view contentView].backgroundColor = [UIColor elt_headerColor];
}


@end
