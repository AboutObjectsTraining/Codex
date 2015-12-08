#import "UIImage+ELTAdditions.h"
#import "ELTObjectStore.h"
#import "ELTDataSource.h"
#import "ELTBookCell.h"

#import "ELTBook.h"
#import "ELTAuthor.h"

@interface ELTDataSource ()
@property (strong, nonatomic) IBOutlet ELTObjectStore *objectStore;
@end


@implementation ELTDataSource

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.objectStore bookAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.objectStore numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.objectStore titleForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objectStore numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELTBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Book"];
    
    [self populateCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Populating Cells

- (void)populateCell:(ELTBookCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ELTBook *book = [self.objectStore bookAtIndexPath:indexPath];
    
    cell.titleLabel.text = book.title;
    cell.infoLabel.text = [NSString stringWithFormat:@"%@ %@", book.year, book.author.fullName];
    cell.bookImageView.image = [UIImage elt_imageForBook:book];
}

@end
