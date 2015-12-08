#import <UIKit/UIKit.h>

@interface ELTDataSource : NSObject <UITableViewDataSource>

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
