#import <UIKit/UIKit.h>


@class GHTrack;

@interface TrackCell : UITableViewCell {
	GHTrack *track;
@private
	IBOutlet UILabel *userLabel;
	IBOutlet UIImageView *gravatarView;
}

@property(nonatomic,retain)GHTrack *track;

@end
