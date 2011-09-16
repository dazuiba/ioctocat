#import <UIKit/UIKit.h>


@class GHBroadcast;

@interface IssueCell : UITableViewCell {
	GHBroadcast *issue;
  @private
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *detailLabel;
    IBOutlet UILabel *votesLabel;    
    IBOutlet UILabel *issueNumber;
	IBOutlet UIImageView *iconView;
}

@property(nonatomic,retain)GHBroadcast *issue;

@end
