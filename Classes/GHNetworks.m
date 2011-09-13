#import "GHNetworks.h"
#import "GHNetworksParserDelegate.h"
#import "GHUser.h"
#import "ASIFormDataRequest.h"

@implementation GHNetworks

@synthesize entries;
@synthesize repository;

+ (id)networksWithRepository:(GHRepository *)theRepository {
	return [[[[self class] alloc] initWithRepository:theRepository] autorelease];
}

- (id)initWithRepository:(GHRepository *)theRepository {
    [super init];
    self.repository = theRepository;
	NSString *urlString = [NSString stringWithFormat:kNetworksFormat, repository.owner, repository.name];
	self.resourceURL = [NSURL URLWithString:urlString];
	return self;    
}

- (void)dealloc {
	[repository release];
	[entries release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHNetworks repository:'%@'>", repository];
}

- (void)parseData:(NSData *)data {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	GHNetworksParserDelegate *parserDelegate = [[GHNetworksParserDelegate alloc] initWithTarget:self andSelector:@selector(parsingJSON:)];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];	
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
	if ([theResult isKindOfClass:[NSError class]]) {
		self.error = theResult;
		self.loadingStatus = GHResourceStatusNotLoaded;
	} else {
		self.entries = theResult;
		self.loadingStatus = GHResourceStatusLoaded;
	}
}

@end
