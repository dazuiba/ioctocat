// Settings
#define kClearAvatarCacheDefaultsKey @"clearAvatarCache"
#define kLastReadingDateURLDefaultsKeyPrefix @"lastReadingDate:"
#define kLoginDefaultsKey @"username"
#define kTokenDefaultsKey @"token"

// API
#define kLoginParamName @"login"
#define kTokenParamName @"token"

// tables
#define kRepositoryCellIdentifier @"RepositoryCell"
#define kFeedEntryCellIdentifier @"FeedEntryCell"
#define kIssueCellIdentifier @"IssueCell"
#define kUserCellIdentifier @"UserCell"
#define kNetworkCellIdentifier @"NetworkCell"
#define kBranchCellIdentifier @"BranchCell"
#define kCommentCellIdentifier @"CommentCell"

// URLs
#define kUserGithubFormat @"http://github.com/%@"
#define kRepositoryGithubFormat @"http://github.com/%@/%@/tree/master"
#define kIssueGithubFormat @"http://github.com/%@/%@/issues#issue/%d"
#define kUserFeedFormat @"http://github.com/%@.atom"
#define kNewsFeedFormat @"http://github.com/%@.private.atom?token=%@"
#define kActivityFeedFormat @"http://github.com/%@.private.actor.atom?token=%@"
#define kRepoFeedFormat @"http://github.com/feeds/%@/commits/%@/%@"
#define kPrivateRepoFeedFormat @"http://github.com/feeds/%@/commits/%@/%@"
#define kUserXMLFormat @"http://github.com/api/v2/xml/user/show/%@"
#define kAuthenticateUserXMLFormat @"http://github.com/api/v2/xml/user/show/%@?login=%@&token=%@"
#define kUserReposFormat @"http://github.com/api/v2/xml/repos/show/%@"
#define kUserWatchedReposFormat @"http://github.com/api/v2/xml/repos/watched/%@"
#define kUserSearchFormat @"http://github.com/api/v2/xml/user/search/%@"
#define kUserFollowingFormat @"http://github.com/api/v2/json/user/show/%@/following"
#define kUserFollowersFormat @"http://github.com/api/v2/json/user/show/%@/followers"
#define kRepoXMLFormat @"http://github.com/api/v2/xml/repos/show/%@/%@"
#define kRepoSearchFormat @"http://github.com/api/v2/xml/repos/search/%@"
#define kPublicRepoCommitsJSONFormat @"http://github.com/api/v2/json/commits/list/%@/%@/%@"
#define kPublicRepoCommitJSONFormat @"http://github.com/api/v2/json/commits/show/%@/%@/%@"
#define kPrivateRepoCommitsJSONFormat @"http://github.com/api/v2/json/commits/list/%@/%@/%@"
#define kPrivateRepoCommitJSONFormat @"http://github.com/api/v2/json/commits/show/%@/%@/%@"
#define kRepoWatchFormat @"http://github.com/api/v2/xml/repos/watch/%@/%@?token=%@"
#define kRepoUnwatchFormat @"http://github.com/api/v2/xml/repos/watch/%@/%@?token=%@"
#define kUserFollowFormat @"http://github.com/api/v2/xml/user/follow/%@?token=%@"
#define kUserUnfollowFormat @"http://github.com/api/v2/xml/user/unfollow/%@?token=%@"
#define kRepoBranchesJSONFormat @"http://github.com/api/v2/json/repos/show/%@/%@/branches"
#define kRepoIssuesXMLFormat @"http://github.com/api/v2/xml/issues/list/%@/%@/%@"
#define kRepoIssueXMLFormat @"http://github.com/api/v2/xml/issues/show/%@/%@/%d"
#define kOpenIssueXMLFormat @"http://github.com/api/v2/xml/issues/open/%@/%@"
#define kEditIssueXMLFormat @"http://github.com/api/v2/xml/issues/edit/%@/%@/%d"
#define kIssueCommentsJSONFormat @"http://github.com/api/v2/json/issues/comments/%@/%@/%d"
#define kIssueCommentJSONFormat @"http://github.com/api/v2/json/issues/comment/%@/%@/%d"
#define KUserFollowingJSONFormat @"http://github.com/api/v2/json/user/show/%@/following"
#define kNetworksFormat @"http://github.com/api/v2/xml/repos/show/%@/%@/network"
#define kFollowUserFormat @"http://github.com/api/v2/json/user/%@/%@"
#define kWatchRepoFormat @"http://github.com/api/v2/json/repos/%@/%@/%@"
#define kIssueToggleFormat @"http://github.com/api/v2/json/issues/%@/%@/%@/%d"

// Issues
#define kIssueStateOpen @"open"
#define kIssueStateClosed @"closed"
#define kIssueToggleClose @"close"
#define kIssueToggleReopen @"reopen"
#define kIssueTitleParamName @"title"
#define kIssueBodyParamName @"body"
#define kIssueCommentCommentParamName @"comment"

// Images
#define kImageGravatarMaxLogicalSize 44

// Following/Watching
#define kFollow @"follow"
#define kUnFollow @"unfollow"
#define kWatch @"watch"
#define kUnWatch @"unwatch"

// KVO
#define kResourceLoadingStatusKeyPath @"loadingStatus"
#define kResourceSavingStatusKeyPath @"savingStatus"
#define kUserLoginKeyPath @"login"
#define kUserGravatarKeyPath @"gravatar"
