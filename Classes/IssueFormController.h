#import <UIKit/UIKit.h>
#import "GHBroadcast.h"


@class IssuesController;

@interface IssueFormController : UITableViewController <UITextFieldDelegate> {
  @private
	GHBroadcast *issue;
	IssuesController *listController;
	IBOutlet UIView *tableFooterView;
	IBOutlet UITextField *titleField;
	IBOutlet UITextView *bodyField;
	IBOutlet UITableViewCell *titleCell;
	IBOutlet UITableViewCell *bodyCell;
	IBOutlet UIActivityIndicatorView *activityView;
	IBOutlet UIButton *saveButton;
}

- (id)initWithIssue:(GHBroadcast *)theIssue andIssuesController:(IssuesController *)theController;
- (IBAction)saveIssue:(id)sender;

@end