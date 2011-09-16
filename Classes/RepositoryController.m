#import "GHUser.h"
#import "GHBranches.h"
#import "GHCommit.h"
#import "LabeledCell.h"
#import "TextCell.h"
#import "RepositoryController.h"
#import "UserController.h"
#import "WebController.h"
#import "iOctocat.h"
#import "FeedEntryCell.h"
#import "FeedEntryController.h"
#import "IssueController.h"
#import "IssueCell.h"
#import "FeedController.h"
#import "IssuesController.h"
#import "NetworkCell.h"
#import "NetworksController.h"
#import "BranchCell.h"


@interface RepositoryController ()
- (void)displayRepository;
@end


@implementation RepositoryController

- (id)initWithRepository:(GHRepository *)theRepository {
    [super initWithNibName:@"Repository" bundle:nil];
	repository = [theRepository retain];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	[repository addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
//	[repository.branches addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
//	self.title = repository.name;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)];
//	self.tableView.tableHeaderView = tableHeaderView;
//	(repository.isLoaded) ? [self displayRepository] : [repository loadData];
//	if (!repository.branches.isLoaded) [repository.branches loadData];
}

- (void)dealloc {
	//[repository.branches removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//	[repository removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//	[repository release];
	[tableHeaderView release];
	[nameLabel release];
	[numbersLabel release];
	[ownerLabel release];
	[websiteLabel release];
	[loadingCell release];
	[ownerCell release];
    [forkLabel release];
	[websiteCell release];
	[descriptionCell release];
    [channelCell release];
    [iconView release];
    [super dealloc];
}

- (GHUser *)currentUser {
	return [[iOctocat sharedInstance] currentUser];
}

- (IBAction)showActions:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:([self.currentUser isWatching:repository] ? @"Stop Watching" : @"Watch"), @"Show on GitHub", nil];
	[actionSheet showInView:self.view.window];
	[actionSheet release];
}
 
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 2) ? @"Branches" : @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 return loadingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 2) return [(TextCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath] height];
	return [(UITableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath] frame].size.height;
}

@end
