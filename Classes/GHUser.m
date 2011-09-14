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
@synthesize entryID;
@synthesize name;
@synthesize login;
@synthesize email;
@synthesize location;
@synthesize bio;
@synthesize url;
@synthesize createdAt;
@synthesize searchTerm;
@synthesize recentActivity;
@synthesize broadcastCount;
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

+ (id)userWithDict:(NSDictionary *)attributes {
	GHUser *user = [GHUser user];
	user.login = [attributes objectForKey:@"login"];
	[self setByDict:attributes];
	return user;
}

- (id)init {
	[super init];
	[self addObserver:self forKeyPath:kUserLoginKeyPath options:NSKeyValueObservingOptionNew context:nil];
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
	[self.avatarPath release];
	[url release];
	[createdAt release];
  [bio release];
	[self.gravatar release];
	
	[self.gravatarLoader release];
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
	login = theLogin;
	// Recent Activity
	NSString *activityFeedURLString = [NSString stringWithFormat:kUserFeedFormat, login];
	NSURL *activityFeedURL = [NSURL URLWithString:activityFeedURLString];
	self.recentActivity = [GHFeed resourceWithURL:activityFeedURL];
}

- (NSURL *)resourceURL {																												
 	return [iOctocat urlWithFormat:kUserFormat, login]; 
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:kUserLoginKeyPath]) {
		NSString *newLogin = [(GHUser *)object login];
		self.following = [[[GHUsers alloc] initWithUser:self andURL:[iOctocat urlWithFormat:kUserFollowingFormat, newLogin]] autorelease];
		self.followers = [[[GHUsers alloc] initWithUser:self andURL:[iOctocat urlWithFormat:kUserFollowersFormat, newLogin]] autorelease];
	}
}

#pragma mark User loading

- (void)loadUser {
	[self loadData];
}


- (void)parsingJSON:(id)theResult {
		DJLog(@""); 
		NSDictionary *user = [theResult objectForKey:@"user"];
		[self setByDict:user];
		self.loadingStatus = GHResourceStatusLoaded;
}

- (void)setByDict:(NSDictionary *)dict{
	self.entryID = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
	self.email =[dict objectForKey:@"email"];
	self.bio = [dict objectForKey:@"bio"];
	self.broadcastCount = [[dict objectForKey:@"broadcast_count"] integerValue];
	self.favoritesCount = [[dict objectForKey:@"favorites_count"] integerValue];
	self.createdAt = [dict objectForKey:@"created_at"];
	self.avatarPath = [dict objectForKey:@"avatar"];
	if(self.avatarPath)
		[self.gravatarLoader loadURL:self.avatarPath];
}

- (BOOL)isAuthenticated{
	return self.email != NULL;
}

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

@end
