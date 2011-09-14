#import "GHRepository.h"
#import "iOctocat.h"
#import "GHReposParserDelegate.h"
#import "GHCommitsParserDelegate.h"
#import "GHIssues.h"
#import "GHNetworks.h"
#import "GHBranches.h"


@implementation GHRepository

@synthesize entryID;
@synthesize name;
@synthesize owner;
@synthesize descriptionText;
@synthesize streamURL;
@synthesize homepageURL;
@synthesize isPrivate;
@synthesize isFork;
@synthesize replies;
@synthesize watchers;
@synthesize openIssues;
@synthesize closedIssues;
@synthesize networks;
@synthesize branches;

+ (id)repositoryWithOwner:(NSString *)theOwner andName:(NSString *)theName {
	return [[[[self class] alloc] initWithOwner:theOwner andName:theName] autorelease];
}

+ (id)repositoryWithDict:(NSDictionary *)dict {
	return [[[[self class] alloc] initWithDict:dict] autorelease];

}

- (id)initWithDict:(NSDictionary *)dict{
	[super init];
	[self setByDict:dict];
	return self;
}

- (id)initWithOwner:(NSString *)theOwner andName:(NSString *)theName {
	[super init];
	[self setOwner:theOwner andName:theName];
	return self;
}

- (void)dealloc {
	[name release];
	[owner release];
	[descriptionText release];
	[streamURL release];
	[homepageURL release];
    [openIssues release];
    [closedIssues release];
    [networks release];
	[branches release];
    [super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	return [self hash] == [anObject hash];
}

- (NSUInteger)hash {
	NSString *hashValue = [NSString stringWithFormat:@"%@/%@", [owner lowercaseString], [name lowercaseString]];
	return [hashValue hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHRepository name:'%@' owner:'%@' descriptionText:'%@' streamURL:'%@'>", name, owner, descriptionText, streamURL];
}

- (NSURL *)resourceURL {
 	return [iOctocat urlWithFormat:kRepoXMLFormat, entryID]; 
}

- (void)setOwner:(NSString *)theOwner andName:(NSString *)theName {
	self.owner = theOwner;
	self.name = theName;
    // Networks
    self.networks = [GHNetworks networksWithRepository:self];
	// Branches
    self.branches = [GHBranches branchesWithRepository:self];
	// Issues
	self.openIssues = [GHIssues issuesWithRepository:self andState:kIssueStateOpen];
	self.closedIssues = [GHIssues issuesWithRepository:self andState:kIssueStateClosed];
}

- (GHUser *)user {
	return [[iOctocat sharedInstance] userWithLogin:owner];
}

- (int)compareByName:(GHRepository *)theOtherRepository {
    return [[self name] localizedCaseInsensitiveCompare:[theOtherRepository name]];
}

#pragma mark Repository loading

- (void)parseData:(NSData *)data {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];	
	GHReposParserDelegate *parserDelegate = [[GHReposParserDelegate alloc] initWithTarget:self andSelector:@selector(parsingJSON:)];
	[parser setDelegate:parserDelegate];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
	[parser release];
	[parserDelegate release];
	[pool release];
}

- (void)parsingJSON:(id)theResult {
		DJLog(@""); 
		// NSDictionary *user = [theResult objectForKey:@""];
		
		self.loadingStatus = GHResourceStatusLoaded;
}

- (void)setByDict:(NSDictionary *)dict{
	self.entryID = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
	self.streamURL =[dict objectForKey:@"stream"];
	NSDictionary *albumDict = [dict objectForKey:@"album"];
	self.avatarPath = [albumDict objectForKey:@"image_url"];
	if(self.avatarPath)
		[self.gravatarLoader loadURL:self.avatarPath];
}

@end
