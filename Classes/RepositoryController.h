#import <UIKit/UIKit.h>


@class GHUser, TextCell, LabeledCell;

@interface RepositoryController : UITableViewController <UIActionSheetDelegate> {
  @private
	IBOutlet UIView *tableHeaderView;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *numbersLabel;
	IBOutlet UILabel *ownerLabel;
	IBOutlet UILabel *websiteLabel;
    IBOutlet UILabel *forkLabel;
	IBOutlet UITableViewCell *loadingCell;
    IBOutlet UITableViewCell *channelCell;
    IBOutlet UITableViewCell *networkCell;    
    IBOutlet UIImageView *iconView;
	IBOutlet LabeledCell *ownerCell;
	IBOutlet LabeledCell *websiteCell;
	IBOutlet TextCell *descriptionCell;
}

@property(nonatomic,readonly) GHUser *currentUser;


@end
