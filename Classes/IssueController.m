#import "IssueController.h"
#import "IssueCommentController.h"
#import "WebController.h"
#import "TextCell.h"
#import "LabeledCell.h"
#import "CommentCell.h"
#import "IssuesController.h"
#import "IssueFormController.h"
#import "GHBroadcastComments.h"
#import "NSDate+Nibware.h"
#import "NSString+Extensions.h"


@interface IssueController ()
- (void)displayIssue;
@end


@implementation IssueController

- (id)initWithIssue:(GHBroadcast *)theIssue andIssuesController:(IssuesController *)theController {    
    [super initWithNibName:@"Issue" bundle:nil];
	issue = [theIssue retain];
	listController = [theController retain];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = [NSString stringWithFormat:@"Issue #%d", issue.num];
    self.tableView.tableHeaderView = tableHeaderView;
	self.tableView.tableFooterView = tableFooterView;
}

// Add and remove observer in the view appearing methods
// because otherwise they will still trigger when the
// issue gets edited by the IssueForm
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[issue addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
	[issue addObserver:self forKeyPath:kResourceSavingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
	[issue.comments addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
	(issue.isLoaded) ? [self displayIssue] : [issue loadData];
	if (!issue.comments.isLoaded) [issue.comments loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[issue.comments removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
	[issue removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
	[issue removeObserver:self forKeyPath:kResourceSavingStatusKeyPath];
}

- (void)dealloc {
	[issue release];
	[listController release];
	[tableHeaderView release];
	[tableFooterView release];
	[titleLabel release];
	[createdLabel release];
    [updatedLabel release];
    [voteLabel release];
	[createdCell release];
	[updatedCell release];
	[descriptionCell release];
	[loadingCommentsCell release];
	[noCommentsCell release];
	[commentCell release];
	[loadingCell release];
    [issueNumber release];
	[iconView release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
		if (object == issue) {
			if (issue.isLoaded) {
				[self displayIssue];
				[self.tableView reloadData];
			} else if (issue.error) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading error" message:@"Could not load the issue" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		} else if (object == issue.comments) {
			if (issue.comments.isLoaded) {
				[self.tableView reloadData];
			} else if (issue.comments.error) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading error" message:@"Could not load the issue comments" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
	} else if ([keyPath isEqualToString:kResourceSavingStatusKeyPath]) {
		if (issue.isSaved) {
			NSString *title = [NSString stringWithFormat:@"Issue %@", (issue.isOpen ? @"reopened" : @"closed")];  
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			[self displayIssue];
			[self.tableView reloadData];
			[listController reloadIssues];
		} else if (issue.error) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request error" message:@"Could not proceed the request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

#pragma mark Actions

- (void)displayIssue {
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActions:)];
    NSString *icon = [NSString stringWithFormat:@"channel_%@.png", issue.state];
	iconView.image = [UIImage imageNamed:icon];
	titleLabel.text = issue.title;
    voteLabel.text = [NSString stringWithFormat:@"%d votes", issue.votes];
    issueNumber.text = [NSString stringWithFormat:@"#%d", issue.num];
	[createdCell setContentText:[issue.created prettyDate]];
	[updatedCell setContentText:[issue.updated prettyDate]];
	[descriptionCell setContentText:issue.body];
}

- (IBAction)showActions:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", (issue.isOpen ? @"Close" : @"Reopen"), @"Add comment", @"Show on GitHub", nil];
	[actionSheet showInView:self.view.window];
	[actionSheet release];
}

- (IBAction)addComment:(id)sender {
	IssueCommentController *viewController = [[IssueCommentController alloc] initWithIssue:issue];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		IssueFormController *formController = [[IssueFormController alloc] initWithIssue:issue andIssuesController:listController];
		[self.navigationController pushViewController:formController animated:YES];
		[formController release];  
	} else if (buttonIndex == 1) {
		issue.isOpen ? [issue closeIssue] : [issue reopenIssue];      
    } else if (buttonIndex == 2) {
		[self addComment:nil];                  
    } else if (buttonIndex == 3) {
		NSString *issueURLString = [NSString stringWithFormat:kIssueGithubFormat, issue.repository.owner, issue.repository.name, issue.num];
        NSURL *issueURL = [NSURL URLWithString:issueURLString];
		WebController *webController = [[WebController alloc] initWithURL:issueURL];
		[self.navigationController pushViewController:webController animated:YES];
		[webController release];                        
    }
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
	if (!issue.isLoaded) return 1;
	if (section == 0) {
		return [issue.body isEmpty] ? 2 : 3;
	}
	if (!issue.comments.isLoaded) return 1;
	if (issue.comments.comments.count == 0) return 1;
	return issue.comments.comments.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 1) ? @"Comments" : @"";
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && !issue.isLoaded) return loadingCell;
	if (indexPath.section == 0 && indexPath.row == 0) return createdCell;             
	if (indexPath.section == 0 && indexPath.row == 1) return updatedCell;
	if (indexPath.section == 0 && indexPath.row == 2) return descriptionCell;
	if (!issue.comments.isLoaded) return loadingCommentsCell;
	if (issue.comments.comments.count == 0) return noCommentsCell;
	
	CommentCell *cell = (CommentCell *)[theTableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
		cell = commentCell;
	}
	GHBroadcastComment *comment = [issue.comments.comments objectAtIndex:indexPath.row];
	[cell setComment:comment];
	return cell;
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 2) return [(TextCell *)descriptionCell height];
	if (indexPath.section == 1 && issue.comments.isLoaded && issue.comments.comments.count > 0) {
		CommentCell *cell = (CommentCell *)[self tableView:theTableView cellForRowAtIndexPath:indexPath];
		return [cell height];
	}
	return 44.0f;
}

@end
