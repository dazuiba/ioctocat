#import "SearchController.h"
#import "UserController.h"
#import "TrackCell.h"


@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Search";
	self.tableView.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	overlayController = [[OverlayController alloc] initWithTarget:self andSelector:@selector(quitSearching:)];
	overlayController.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
	GHSearch *userSearch = [GHSearch searchWithURLFormat:kUserSearchFormat];
	GHSearch *repoSearch = [GHSearch searchWithURLFormat:kRepoSearchFormat];
	searches = [[NSArray alloc] initWithObjects:userSearch, repoSearch, nil];
	for (GHSearch *search in searches) [search addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
	for (GHSearch *search in searches) [search removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
	[userCell release];
	[trackCell release];
	[searches release];
	[overlayController release];
	[searchBar release];
	[searchControl release];
	[loadingCell release];
	[noResultsCell release];
    [super dealloc];
}

- (GHSearch *)currentSearch {
	return searchControl.selectedSegmentIndex == UISegmentedControlNoSegment ? 
		nil : [searches objectAtIndex:searchControl.selectedSegmentIndex];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
		[self.tableView reloadData];
		GHSearch *search = (GHSearch *)object;
		if (!search.isLoading && search.error) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading error" message:@"Could not load the search results" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

#pragma mark Actions

- (IBAction)switchChanged:(id)sender {
	[self.tableView reloadData];
	searchBar.text = self.currentSearch.searchTerm;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	[self.tableView insertSubview:overlayController.view aboveSubview:self.parentViewController.view];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(quitSearching:)] autorelease];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	self.currentSearch.searchTerm = searchBar.text;
	[self.currentSearch loadData];
	[self quitSearching:nil];
}

- (void)quitSearching:(id)sender {
	searchBar.text = self.currentSearch.searchTerm;
	[searchBar resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
	[overlayController.view removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentSearch.isLoading) return 1;
	if (self.currentSearch.isLoaded && self.currentSearch.results.count == 0) return 1;
	DJLog(@"count: %d",self.currentSearch.results.count);
	return self.currentSearch.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DJLog(@"row: %d",indexPath.row);
    if (!self.currentSearch.isLoaded) return loadingCell;
    if (self.currentSearch.results.count == 0) return noResultsCell;
	id object = [self.currentSearch.results objectAtIndex:indexPath.row];
	if ([object isKindOfClass:[GHTrack class]]) {
		DJLog(@"cell GHTrack");
		TrackCell *cell = (TrackCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
		if (cell == nil) {
			DJLog(@"cell before");
			[[NSBundle mainBundle] loadNibNamed:@"TrackCell" owner:self options:nil];
			DJLog(@"cell after");
			cell = trackCell;
		}
		cell.track = (GHTrack *)object;
		return cell;
	} else if ([object isKindOfClass:[GHUser class]]) {
		UserCell *cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:kUserCellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
			cell = userCell;
		}
		cell.user = (GHUser *)object;
		return cell;
	}
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result = 44.0;
	if (!self.currentSearch.isLoaded) return result;
	if (self.currentSearch.results.count == 0) return result;
	id object = [self.currentSearch.results objectAtIndex:0];
	if ([object isKindOfClass:[GHTrack class]]) {
		return 81.0;
	}else {
		return result;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
 	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	[self showActionSheet];
}

- (void)showActionSheet
{
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
																													 delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
																									otherButtonTitles:@"播放", @"分享",@"取消", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//	actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

// Action sheet delegate method.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	id object = [self.currentSearch.results objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
	
	if (buttonIndex == 0)
	{
		DJLog(@"%@",object);
	}
}


@end

