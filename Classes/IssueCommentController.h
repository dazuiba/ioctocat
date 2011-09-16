#import <UIKit/UIKit.h>
#import "GHBroadcast.h"

@class GHComment;

@interface IssueCommentController : UIViewController <UITextFieldDelegate> {
  @private
	GHComment *comment;
	GHBroadcast *issue;
	IBOutlet UITextView *bodyView;
	IBOutlet UIBarButtonItem *postButton;
	IBOutlet UIActivityIndicatorView *activityView;
}

- (id)initWithIssue:(GHBroadcast *)theIssue;
- (IBAction)postComment:(id)sender;

@end