
// URLs
#define kURLFormat @"http://localhost:3000/api/v1%@"
#define kUserFormat @"/user/show/?login=%@"
#define kInboxFormat @"/private.atom?box=%@"
#define kUserFollowingFormat @"/user/following?login=%@"
#define kUserFollowersFormat @"/user/followers?login=%@"

#define kUserSearchFormat @"/user/search?q=%@"
#define kRepoSearchFormat @"/ml/search?q=%@"
#define kRepoXMLFormat @"/broadcast/show?id=%d"
#define kBroadcastFormat @"/broadcast/show?id=%d"

// Messages
#define kAppErrorDomain @"Iq84FMErrorDomain"

#define kMsgLoginFailedExplain @"您输入的用户名或密码有误，请重试。"
#define kMsgLoginFailedTitle @"验证失败"
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
#define kProfileStatCellIdentifier @"ProfileStatCell"
#define kBranchCellIdentifier @"BranchCell"
#define kCommentCellIdentifier @"CommentCell"





#define kAuthenticateUserXMLFormat @"/user/show/%@?login=%@&token=%@"


#define kUserGithubFormat @"http://localhost:3000/%@"
#define kRepositoryGithubFormat @"http://localhost:3000/%@/%@/tree/master"
#define kIssueGithubFormat @"http://localhost:3000/%@/%@/issues#issue/%d"
#define kUserFeedFormat @"http://localhost:3000/%@.atom"
#define kRepoFeedFormat @"http://localhost:3000/feeds/%@/commits/%@/%@"
#define kPrivateRepoFeedFormat @"http://localhost:3000/feeds/%@/commits/%@/%@"
#define kUserReposFormat @"http://localhost:3000/api/v2/xml/repos/show/%@"
#define kUserWatchedReposFormat @"http://localhost:3000/api/v2/xml/repos/watched/%@"

#define kPublicRepoCommitsJSONFormat @"http://localhost:3000/api/v2/json/commits/list/%@/%@/%@"
#define kPublicRepoCommitJSONFormat @"http://localhost:3000/api/v2/json/commits/show/%@/%@/%@"
#define kPrivateRepoCommitsJSONFormat @"http://localhost:3000/api/v2/json/commits/list/%@/%@/%@"
#define kPrivateRepoCommitJSONFormat @"http://localhost:3000/api/v2/json/commits/show/%@/%@/%@"
#define kRepoWatchFormat @"http://localhost:3000/api/v2/xml/repos/watch/%@/%@?token=%@"
#define kRepoUnwatchFormat @"http://localhost:3000/api/v2/xml/repos/watch/%@/%@?token=%@"
#define kUserFollowFormat @"http://localhost:3000/api/v2/xml/user/follow/%@?token=%@"
#define kUserUnfollowFormat @"http://localhost:3000/api/v2/xml/user/unfollow/%@?token=%@"
#define kRepoBranchesJSONFormat @"http://localhost:3000/api/v2/json/repos/show/%@/%@/branches"
#define kRepoIssuesXMLFormat @"http://localhost:3000/api/v2/xml/issues/list/%@/%@/%@"
#define kOpenIssueXMLFormat @"http://localhost:3000/api/v2/xml/issues/open/%@/%@"
#define kEditIssueXMLFormat @"http://localhost:3000/api/v2/xml/issues/edit/%@/%@/%d"
#define kIssueCommentsJSONFormat @"http://localhost:3000/api/v2/json/issues/comments/%@/%@/%d"
#define kIssueCommentJSONFormat @"http://localhost:3000/api/v2/json/issues/comment/%@/%@/%d"
#define kNetworksFormat @"http://localhost:3000/api/v2/xml/repos/show/%@/%@/network"
#define kFollowUserFormat @"http://localhost:3000/api/v2/json/user/%@/%@"
#define kWatchRepoFormat @"http://localhost:3000/api/v2/json/repos/%@/%@/%@"
#define kIssueToggleFormat @"http://localhost:3000/api/v2/json/issues/%@/%@/%@/%d"

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
