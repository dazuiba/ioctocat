#import "IssuesController.h"
#import "IssueController.h"
#import "IssueFormController.h"
#import "GHBroadcast.h"


@interface IssuesController ()
- (void)issueLoadingStarted;
- (void)issueLoadingFinished;
@end


@implementation IssuesController

//@synthesize repository;
//
//- (id)initWithRepository:(GHRepository *)theRepository {
//    [super initWithNibName:@"Issues" bundle:nil];
//	self.title = @"Issues";
//    self.repository = theRepository;
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.navigationItem.titleView = channelControl;
//	self.navigationItem.rightBarButtonItem = addButton;
//    issueList = [[NSArray alloc] initWithObjects:repository.openIssues, repository.closedIssues, nil];
//	for (GHChannel *channel in issueList) [channel addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
//	channelControl.selectedSegmentIndex = 0;
//    if (!self.currentIssues.isLoaded) [self.currentIssues loadData];
//}
//
//- (void)dealloc {
//	for (GHChannel *channel in issueList) [channel removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//	[addButton release];
//	[channelControl release];
//	[loadingIssuesCell release];
//	[noIssuesCell release];
//	[issueCell release];
//    [issueList release];
//    [repository release];
//    [super dealloc];
//}
//
//- (GHChannel *)currentIssues {
//	return channelControl.selectedSegmentIndex == UISegmentedControlNoSegment ? 
//		nil : [issueList objectAtIndex:channelControl.selectedSegmentIndex];
//}
//
//#pragma mark Actions
//
//- (IBAction)switchChanged:(id)sender {
//    [self.tableView reloadData];
//    if (self.currentIssues.isLoaded) return;
//    [self.currentIssues loadData];
//    [self.tableView reloadData];    
//}
//
//- (IBAction)createNewIssue:(id)sender {
//	GHBroadcast *newIssue = [[GHBroadcast alloc] init];
//	newIssue.repository = repository;
//	IssueFormController *formController = [[IssueFormController alloc] initWithIssue:newIssue andIssuesController:self];
//	[self.navigationController pushViewController:formController animated:YES];
//	[formController release];
//	[newIssue release];
//}
//
//- (void)reloadIssues {
//	for (GHChannel *channel in issueList) [channel loadData];
//	[self.tableView reloadData];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//	if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
//		GHChannel *theIssues = (GHChannel *)object;
//		if (theIssues.isLoading) {
//			[self issueLoadingStarted];
//		} else {
//			[self issueLoadingFinished];
//			if (!theIssues.error) return;
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading error" message:@"Could not load the channel" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//			[alert show];
//			[alert release];
//		}
//	}
//}
//
//- (void)issueLoadingStarted {
//	loadCounter += 1;
//}
//
//- (void)issueLoadingFinished {
//	[self.tableView reloadData];
//	loadCounter -= 1;
//	if (loadCounter > 0) return;
//}
//
//#pragma mark TableView
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return (self.currentIssues.isLoading ) || (self.currentIssues.entries.count == 0) ? 1 : self.currentIssues.entries.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (self.currentIssues.isLoading) return loadingIssuesCell;
//	if (self.currentIssues.entries.count == 0) return noIssuesCell;
//	IssueCell *cell = (IssueCell *)[tableView dequeueReusableCellWithIdentifier:kIssueCellIdentifier];
//	if (cell == nil) {
//		[[NSBundle mainBundle] loadNibNamed:@"IssueCell" owner:self options:nil];
//		cell = issueCell;
//	}
//	cell.issue = [self.currentIssues.entries objectAtIndex:indexPath.row];
//	return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	GHBroadcast *issue = [self.currentIssues.entries objectAtIndex:indexPath.row];
//	IssueController *issueController = [[IssueController alloc] initWithIssue:issue andIssuesController:self];
//	[self.navigationController pushViewController:issueController animated:YES];
//	[issueController release];
//}

@end

