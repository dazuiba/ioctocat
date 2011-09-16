#import "UserController.h"
#import "RepositoryController.h"
#import "WebController.h"
#import "GHUser.h"
#import "LabeledCell.h"
#import "RepositoryCell.h"
#import "GravatarLoader.h"
#import "iOctocat.h"
#import "UsersController.h"
#import "ASIFormDataRequest.h"
#import "FeedController.h"
#import "NSString+Extensions.h"


@interface UserController ()
- (void)displayUser;
@end


@implementation UserController

@synthesize user;

- (id)initWithUser:(GHUser *)theUser {
  [super initWithNibName:@"User" bundle:nil];
	self.user = theUser;
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!user) self.user = self.currentUser; // Set to currentUser in case this controller is initialized from the TabBar
	if (!self.currentUser.following.isLoaded) [self.currentUser.following loadData];
	[user addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
	[user addObserver:self forKeyPath:kUserGravatarKeyPath options:NSKeyValueObservingOptionNew context:nil];
	(user.isLoaded) ? [self displayUser] : [user loadUser];
	self.navigationItem.title = user.login;
	self.tableView.tableHeaderView = tableHeaderView;
  //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:[iOctocat sharedInstance] action:@selector(presentPlayer:nil)];
}

- (void)dealloc {
	[user removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
	[user removeObserver:self forKeyPath:kUserGravatarKeyPath];
	[user release];
	[tableHeaderView release];
	[nameLabel release];
	[companyLabel release];
	[locationLabel release];
	[blogLabel release];
	[emailLabel release];
	[locationCell release];
	[blogCell release];
	[emailCell release];
    [followersCell release];
    [followingCell release];
	[recentActivityCell release];
	[loadingUserCell release];
	[loadingReposCell release];
	[noPublicReposCell release];
    [super dealloc];
}

- (GHUser *)currentUser {
	return [[iOctocat sharedInstance] currentUser];
}

#pragma mark Actions

- (IBAction)showActions:(id)sender {
	UIActionSheet *actionSheet;
	if ([self.currentUser isEqual:user]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in GitHub",  nil];
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:([self.currentUser isFollowing:user] ? @"Stop Following" : @"Follow"), @"Open in GitHub",  nil];
	}
	[actionSheet showInView:self.view.window];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (![self.currentUser isEqual:user] && buttonIndex == 0) {
		[self.currentUser isFollowing:user] ? [self.currentUser unfollowUser:user] : [self.currentUser followUser:user];
    } else if ([self.currentUser isEqual:user] && buttonIndex == 0 || ![self.currentUser isEqual:user] && buttonIndex == 1) {
		NSString *userURLString = [NSString stringWithFormat:kUserGithubFormat, user.login];
        NSURL *userURL = [NSURL URLWithString:userURLString];
		WebController *webController = [[WebController alloc] initWithURL:userURL];
		[self.navigationController pushViewController:webController animated:YES];
		[webController release];             
    }
}

- (void)displayUser {
	nameLabel.text = (!user.name || [user.name isEmpty]) ? user.login : user.name;
	companyLabel.text = user.bio;
	gravatarView.image = user.gravatar;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kUserGravatarKeyPath]) {
		gravatarView.image = user.gravatar;
	} else if (object == user && [keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
		if (user.isLoaded) {
			[self displayUser];
			[self.tableView reloadData];
		} else if (user.error) {
			NSString *message = [NSString stringWithFormat:@"Could not load the user %@", user.login];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (!user.isLoaded) return 1;
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!user.isLoaded) return 1;
	if (section == 0) return 3;
  if (section == 1) return 3;
	if (section == 2) return 2;
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 2) ? @"Repositories" : @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	if (!user.isLoaded) return loadingUserCell;
	if (section == 0) {
		LabeledCell *cell;
		switch (row) {
			case 0: cell = locationCell; break;
			case 1: cell = blogCell; break;
			case 2: cell = emailCell; break;
			default: cell = nil;
		}
		BOOL isSelectable = row != 0 && cell.hasContent;
		cell.selectionStyle = isSelectable ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
		cell.accessoryType = isSelectable ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
		return cell;
	}
	if (section == 1 && row == 0) return recentActivityCell;
	if (section == 1 && row == 1) return followingCell;
	if (section == 1 && row == 2) return followersCell;
	if (section == 2) {
		UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kProfileStatCellIdentifier];
    if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileStatCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    }
 		NSString *format = @"%@(%d首)";
		if(indexPath.row == 0){ 
			cell.imageView.image = [UIImage imageNamed: @"public.png"];
			cell.textLabel.text = [NSString stringWithFormat:format, @"分享的歌曲", user.broadcastCount];
		}else {
			cell.imageView.image = [UIImage imageNamed: @"private.png"];
			cell.textLabel.text = [NSString stringWithFormat:format, @"收藏的歌曲", user.favoritesCount];
		}
		return cell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	UIViewController *viewController = nil;
	if (section == 1 && row == 0) {
    viewController = [[FeedController alloc] initWithFeed:user.recentActivity andTitle:@"Recent Activity"];     
	} else if (section == 1) {
    viewController = [[UsersController alloc] initWithUsers:(row == 1 ? user.following : user.followers)];
		viewController.title = (row == 1) ? @"Following" : @"Followers";         
	}
	// Maybe push a controller
	if (viewController) {
		viewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

@end
