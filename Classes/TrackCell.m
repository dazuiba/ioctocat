#import "TrackCell.h"
#import "GHRepository.h"


@implementation TrackCell

@synthesize track;

- (void)dealloc {
	[track removeObserver:self forKeyPath:kUserGravatarKeyPath];
	[track release];
    [userLabel release];
    [gravatarView release];
    [super dealloc];
}

- (void)setTrack:(GHRepository *)aTrack {
	[aTrack retain];
	[track release];
	track = aTrack;
	userLabel.text = track.name;
	[track addObserver:self forKeyPath:kUserGravatarKeyPath options:NSKeyValueObservingOptionNew context:nil];
    gravatarView.image = track.gravatar;
	if (!gravatarView.image && !track.isLoaded) [track loadTrack];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kUserGravatarKeyPath] && track.gravatar) {
		gravatarView.image = track.gravatar;
	}
}

@end
