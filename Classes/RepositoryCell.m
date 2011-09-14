#import "RepositoryCell.h"


@implementation RepositoryCell

@synthesize repository;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	[super initWithStyle:style reuseIdentifier:reuseIdentifier];
	self.textLabel.font = [UIFont systemFontOfSize:16.0f];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.opaque = YES;
	return self;
}

- (void)dealloc {
	[repository release];
    [super dealloc];
}

- (void)setRepository:(GHRepository *)theRepository {
	[theRepository retain];
	[repository release];
	repository = theRepository;
	self.textLabel.text = repository.name;
	[repository addObserver:self forKeyPath:kUserGravatarKeyPath options:NSKeyValueObservingOptionNew context:nil];
//    gravatarView.image = user.gravatar;
//	if (!gravatarView.image && !user.isLoaded) [user loadUser];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//	if ([keyPath isEqualToString:kUserGravatarKeyPath] && repository.gravatar) {
//		gravatarView.image = repository.gravatar;
//	}
}

@end
