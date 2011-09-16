#import <UIKit/UIKit.h>
#import "GHSearch.h"
#import "OverlayController.h"
#import "RepositoryCell.h"
#import "UserCell.h"
#import "TrackCell.h"


@interface SearchController : UITableViewController {
  @private
	IBOutlet UISearchBar *searchBar;
	IBOutlet UISegmentedControl *searchControl;
	IBOutlet UITableViewCell *loadingCell;
	IBOutlet UITableViewCell *noResultsCell;
	IBOutlet TrackCell *trackCell; 
	UserCell *userCell;
	OverlayController *overlayController;
	NSArray *searches;
}

@property(nonatomic,readonly)GHSearch *currentSearch;

- (void)quitSearching:(id)sender;
- (IBAction)switchChanged:(id)sender;

@end
