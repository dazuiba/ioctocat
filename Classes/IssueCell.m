#import "IssueCell.h"
#import "GHBroadcast.h"
#import "GHUser.h"
#import "NSDate+Nibware.h"


@implementation IssueCell

@synthesize issue;

- (void)dealloc {
	[issue release];
	[dateLabel release];
	[titleLabel release];
	[detailLabel release];    
    [votesLabel release];        
    [iconView release];        
    [super dealloc];
}

- (void)setIssue:(GHBroadcast *)anIssue {
	[issue release];
	issue = [anIssue retain];
	titleLabel.text = issue.title;
    detailLabel.text = issue.body;
    issueNumber.text = [NSString stringWithFormat:@"#%d", issue.num];
	dateLabel.text = [NSString stringWithFormat:@"updated %@", [issue.updated prettyDate]];
	// Icon
	NSString *icon = [NSString stringWithFormat:@"channel_%@.png", issue.state];
	iconView.image = [UIImage imageNamed:icon];
}

@end
