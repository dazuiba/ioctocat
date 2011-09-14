#import <UIKit/UIKit.h>


@class GHRepository;

@interface TrackCell : UITableViewCell {
	GHRepository *track;
@private
	IBOutlet UILabel *userLabel;
	IBOutlet UIImageView *gravatarView;
}

@property(nonatomic,retain)GHRepository *track;

@end
