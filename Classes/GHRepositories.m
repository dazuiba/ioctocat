#import "GHRepositories.h"
#import "GHUser.h"
#import "iOctocat.h"
#import "ASIFormDataRequest.h"
#import "GHReposParserDelegate.h"


@implementation GHRepositories

@synthesize user;
@synthesize repositories;

+ (id)repositoriesWithUser:(GHUser *)theUser andURL:(NSURL *)theURL {
	return [[[[self class] alloc] initWithUser:theUser andURL:theURL] autorelease];
}

- (id)initWithUser:(GHUser *)theUser andURL:(NSURL *)theURL {
    [super init];
    self.user = theUser;
    self.resourceURL = theURL;
	self.repositories = [NSMutableArray array];
	return self;
}

- (void)dealloc {
	[repositories release], repositories = nil;
	[user release], user = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHRepositories user:'%@' resourceURL:'%@'>", user, resourceURL];
}

- (void)parsingJSON:(id)theResult {
	[theResult sortUsingSelector:@selector(compareByName:)];
	self.repositories = theResult;
	self.loadingStatus = GHResourceStatusLoaded;
}

@end
