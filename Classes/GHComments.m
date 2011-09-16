#import "GHComments.h"
#import "GHComment.h"
#import "GHBroadcast.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"


@implementation GHComments

@synthesize comments;
@synthesize issue;

+ (id)commentsWithIssue:(GHBroadcast *)theIssue {
	return [[[[self class] alloc] initWithIssue:theIssue] autorelease];
}

- (id)initWithIssue:(GHBroadcast *)theIssue {
	[super init];
	self.issue = theIssue;
	self.comments = [NSMutableArray array];
	return self;
}

- (void)dealloc {
	[comments release], comments = nil;
	[issue release], issue = nil;
	[super dealloc];
}

- (NSURL *)resourceURL {
	// Dynamic resourceURL, because it depends on the
	// issue num which isn't always available in advance
	NSString *urlString = [NSString stringWithFormat:kIssueCommentsJSONFormat, issue.repository.owner, issue.repository.name, issue.num];
	return [NSURL URLWithString:urlString];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHBroadcastComments issue:'%@'>", issue];
}

- (void)parseData:(NSData *)data {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSError *parseError = nil;
    NSDictionary *resultDict = [[CJSONDeserializer deserializer] deserialize:data error:&parseError];
    NSMutableArray *resources = [NSMutableArray array];
	for (NSDictionary *dict in [resultDict objectForKey:@"comments"]) {
		GHBroadcastComment *comment = [[GHBroadcastComment alloc] initWithIssue:issue andDictionary:dict];
		[resources addObject:comment];
		[comment release];
	}
    id res = parseError ? (id)parseError : (id)resources;
	[self performSelectorOnMainThread:@selector(parsingJSON:) withObject:res waitUntilDone:YES];
    [pool release];
}

- (void)parsingJSON:(id)theResult {
	if ([theResult isKindOfClass:[NSError class]]) {
		self.error = theResult;
		self.loadingStatus = GHResourceStatusNotLoaded;
	} else {
		self.comments = theResult;
		self.loadingStatus = GHResourceStatusLoaded;
	}
}

@end
