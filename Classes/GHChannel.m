#import "GHChannel.h"
#import "GHChannelParserDelegate.h"
#import "GHUser.h"
#import "ASIFormDataRequest.h"


@implementation GHChannel
//
//@synthesize entries;
//@synthesize repository;
//@synthesize issueState;
//
//+ (id)channelWithRepository:(GHRepository *)theRepository andState:(NSString *)theState {
//	return [[[[self class] alloc] initWithRepository:theRepository andState:theState] autorelease];
//}
//
//- (id)initWithRepository:(GHRepository *)theRepository andState:(NSString *)theState {
//    [super init];
//    self.repository = theRepository;
//    self.issueState = theState;
//	NSString *urlString = [NSString stringWithFormat:kRepoIssuesXMLFormat, repository.owner, repository.name, issueState];
//	self.resourceURL = [NSURL URLWithString:urlString];	
//	
//	return self;    
//}
//
//- (void)dealloc {
//	[repository release];
//	[issueState release];
//	[entries release];
//    [super dealloc];
//}
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<GHChannel repository:'%@' state:'%@'>", repository, issueState];
//}
//
//- (void)parseData:(NSData *)data {
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	GHChannelParserDelegate *parserDelegate = [[GHChannelParserDelegate alloc] initWithTarget:self andSelector:@selector(parsingJSON:)];
//	parserDelegate.repository = repository;
//	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];	
//	[parser setDelegate:parserDelegate];
//	[parser setShouldProcessNamespaces:NO];
//	[parser setShouldReportNamespacePrefixes:NO];
//	[parser setShouldResolveExternalEntities:NO];
//	[parser parse];
//	[parser release];
//	[parserDelegate release];
//	[pool release];
//}
//
//- (void)parsingJSON:(id)theResult {
//	if ([theResult isKindOfClass:[NSError class]]) {
//		self.error = theResult;
//		self.loadingStatus = GHResourceStatusNotLoaded;
//	} else {
//		self.entries = theResult;
//		self.loadingStatus = GHResourceStatusLoaded;
//	}
//}

@end
