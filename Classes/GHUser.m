#import "GHUser.h"
#import "GHFeed.h"
#import "GHRepository.h"
#import "GravatarLoader.h"
#import "GHReposParserDelegate.h"
#import "GHUsersParserDelegate.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "NSString+Extensions.h"
#import "iOctocat.h"


@interface GHUser ()
- (void)parseXMLWithToken:(NSString *)token;
- (void)setFollowing:(NSString *)theMode forUser:(GHUser *)theUser;
- (void)setWatching:(NSString *)theMode forRepository:(GHRepository *)theRepository;
- (void)followToggleFinished:(ASIHTTPRequest *)request;
- (void)followToggleFailed:(ASIHTTPRequest *)request;
- (void)watchToggleFinished:(ASIHTTPRequest *)request;
- (void)watchToggleFailed:(ASIHTTPRequest *)request;
@end


@implementation GHUser

@synthesize name;
@synthesize login;
@synthesize email;
@synthesize location;
@synthesize bio;
@synthesize avatarPath;
@synthesize url;
@synthesize createdAt;
@synthesize searchTerm;
@synthesize gravatar;
@synthesize isAuthenticated;
@synthesize recentActivity;
@synthesize listenersCount;
@synthesize favoritesCount;
@synthesize following;
@synthesize followers;

+ (id)user {
	return [[[[self class] alloc] init] autorelease];
}

+ (id)userForSearchTerm:(NSString *)theSearchTerm {
	GHUser *user = [GHUser user];
	user.searchTerm = theSearchTerm;
	return user;
}

+ (id)userWithLogin:(NSString *)theLogin {
	GHUser *user = [GHUser user];
	user.login = theLogin;
	return user;
}

- (id)init {
	[super init];
	[self addObserver:self forKeyPath:kUserLoginKeyPath options:NSKeyValueObservingOptionNew context:nil];
	isAuthenticated = NO;
	gravatarLoader = [[GravatarLoader alloc] initWithTarget:self andHandle:@selector(loadedGravatar:)];
	return self;
}

- (id)initWithLogin:(NSString *)theLogin {
	[self init];
	self.login = theLogin;
	self.gravatar = [UIImage imageWithContentsOfFile:self.cachedGravatarPath];
	return self;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:kUserLoginKeyPath];
	[name release];
	[login release];
	[email release];
	[location release];
	[searchTerm release];
	[avatarPath release];
	[url release];
	[createdAt release];
  [bio release];
	[gravatar release];
	
	[gravatarLoader release];
	[recentActivity release];
  [following release];
  [followers release];
  [super dealloc];
}

- (NSUInteger)hash {
	NSString *hashValue = [login lowercaseString];
	return [hashValue hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHUser login:'%@' name:'%@' >", login, name];
}

- (int)compareByName:(GHUser *)theOtherUser {
    return [login localizedCaseInsensitiveCompare:[theOtherUser login]];
}

- (void)setLogin:(NSString *)theLogin {
	[theLogin retain];
	[login release];
	[resourceURL release];
	login = theLogin;
	// Build Resource URL
	NSString *urlString = [NSString stringWithFormat:kUserFormat, login];
	self.resourceURL = [NSURL URLWithString:urlString];
	
	// Repositories
	NSString *repositoriesURLString = [NSString stringWithFormat:kUserReposFormat, login];
	NSString *watchedRepositoriesURLString = [NSString stringWithFormat:kUserWatchedReposFormat, login];
	NSURL *repositoriesURL = [NSURL URLWithString:repositoriesURLString];
	NSURL *watchedRepositoriesURL = [NSURL URLWithString:watchedRepositoriesURLString];
	// Recent Activity
	NSString *activityFeedURLString = [NSString stringWithFormat:kUserFeedFormat, login];
	NSURL *activityFeedURL = [NSURL URLWithString:activityFeedURLString];
	self.recentActivity = [GHFeed resourceWithURL:activityFeedURL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kUserLoginKeyPath]) {
		NSString *newLogin = [(GHUser *)object login];
		NSString *followingURLString = [NSString stringWithFormat:kUserFollowingFormat, newLogin];
		NSString *followersURLString = [NSString stringWithFormat:kUserFollowersFormat, newLogin];
		NSURL *followingURL = [NSURL URLWithString:followingURLString];
		NSURL *followersURL = [NSURL URLWithString:followersURLString];
		self.following = [[[GHUsers alloc] initWithUser:self andURL:followingURL] autorelease];
		self.followers = [[[GHUsers alloc] initWithUser:self andURL:followersURL] autorelease];
	}
}

#pragma mark User loading

- (void)loadUser {
	// if (self.isLoading) return;
	// self.error = nil;
	// self.loadingStatus = GHResourceStatusLoading;
	// [self performSelectorInBackground:@selector(parseXMLWithToken:) withObject:nil];
	[self loadData];
}

- (void)authenticateWithToken:(NSString *)theToken {
	if (self.isLoading) return;
	self.error = nil;
	self.loadingStatus = GHResourceStatusLoading;
	[self performSelectorInBackground:@selector(parseXMLWithToken:) withObject:theToken];
}

// - (void)parseXMLWithToken:(NSString *)token {
// 	
// 	
// 	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
// 	NSString *userURLString;
// 	if (login) {
// 		userURLString = token ? [NSString stringWithFormat:kAuthenticateUserXMLFormat, login, login, token] : [NSString stringWithFormat:kUserXMLFormat, login];
// 	} else {
// 		userURLString = [NSString stringWithFormat:kUserSearchFormat, searchTerm];
// 	}
// 	NSURL *userURL = [NSURL URLWithString:userURLString];    
// 	GHUsersParserDelegate *parserDelegate = [[GHUsersParserDelegate alloc] initWithTarget:self andSelector:@selector(loadedUsers:)];
// 	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:userURL];
// 	[parser setDelegate:parserDelegate];
// 	[parser setShouldProcessNamespaces:NO];
// 	[parser setShouldReportNamespacePrefixes:NO];
// 	[parser setShouldResolveExternalEntities:NO];
// 	[parser parse];
// 	[parser release];
// 	[parserDelegate release];
// 	[pool release];
// }

- (NSInteger)gravatarSize {
	UIScreen *mainScreen = [UIScreen mainScreen];
	CGFloat deviceScale = ([mainScreen respondsToSelector:@selector(scale)]) ? [mainScreen scale] : 1.0;
	NSInteger size = kImageGravatarMaxLogicalSize * MAX(deviceScale, 1.0);
	return size;
}

- (void)parsingJSON:(id)theResult {
		NSDictionary *user = [theResult objectForKey:@"user"];
		self.name = [user objectForKey:@"name"];
		self.login =[user objectForKey:@"login"];
		self.bio = [user objectForKey:@"bio"];
		self.listenersCount = [user objectForKey:@"listenersCount"];
		self.favoritesCount = [user objectForKey:@"favoritesCount"];
		self.createdAt = [user objectForKey:@"created_at"];
		self.avatarPath = [user objectForKey:@"avatar"];
		[gravatarLoader loadUrl:avatarPath];
}


// - (void)loadedUsers:(id)theResult {
// 	if ([theResult isKindOfClass:[NSError class]]) {
// 		self.error = theResult;
// 	} else if ([(NSArray *)theResult count] > 0) {
// 		GHUser *user = [(NSArray *)theResult objectAtIndex:0];
// 		if (!login || [login isEmpty]) self.login = user.login;
// 		self.name = user.name;
// 		self.email = user.email;
// 		self.company = user.company;
// 		self.location = user.location;
// 		self.gravatarHash = user.gravatarHash;
// 		self.blogURL = user.blogURL;
// 		self.publicGistCount = user.publicGistCount;
// 		self.privateGistCount = user.privateGistCount;
// 		self.publicRepoCount = user.publicRepoCount;
// 		self.privateRepoCount = user.privateRepoCount;
// 		self.isAuthenticated = user.isAuthenticated;
// 		if (gravatarHash) [gravatarLoader loadHash:gravatarHash withSize:[self gravatarSize]];
// 		else if (email) [gravatarLoader loadEmail:email withSize:[self gravatarSize]];
// 	}
// 	self.loadingStatus = GHResourceStatusLoaded;
// }

#pragma mark Following

- (BOOL)isFollowing:(GHUser *)anUser {
	if (!following.isLoaded) [following loadData];
	return [following.users containsObject:anUser];
}

- (void)followUser:(GHUser *)theUser {
	[following.users addObject:theUser];
	[self setFollowing:kFollow forUser:theUser];
}

- (void)unfollowUser:(GHUser *)theUser {
	[following.users removeObject:theUser];
	[self setFollowing:kUnFollow forUser:theUser];
}

- (void)setFollowing:(NSString *)theMode forUser:(GHUser *)theUser {
	NSString *followingURLString = [NSString stringWithFormat:kFollowUserFormat, theMode, theUser.login];
	NSURL *followingURL = [NSURL URLWithString:followingURLString];
    ASIFormDataRequest *request = [GHResource authenticatedRequestForURL:followingURL];
	[request setDelegate:self];
	[request setRequestMethod:@"POST"];
	[request setDidFinishSelector:@selector(followToggleFinished:)];
	[request setDidFailSelector:@selector(followToggleFailed:)];
	[[iOctocat queue] addOperation:request];
}

- (void)followToggleFinished:(ASIHTTPRequest *)request {
	DJLog(@"Follow toggle %@ finished: %@", [request url], [request responseString]);
	self.following.loadingStatus = GHResourceStatusNotLoaded;
    [self.following loadData];
}

- (void)followToggleFailed:(ASIHTTPRequest *)request {
	DJLog(@"Follow toggle %@ failed: %@", [request url], [request error]);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not change following status." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark Gravatar

- (void)loadedGravatar:(UIImage *)theImage {
	self.gravatar = theImage;
	[UIImagePNGRepresentation(theImage) writeToFile:self.cachedGravatarPath atomically:YES];
}

- (NSString *)cachedGravatarPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *imageName = [NSString stringWithFormat:@"%@.png", login];
	return [documentsPath stringByAppendingPathComponent:imageName];
}

@end
