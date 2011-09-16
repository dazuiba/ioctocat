#import "GHBroadcast.h"
#import "GHTrack.h"
#import "GHChannelParserDelegate.h"
#import "GHBroadcastComment.h"
#import "GHBroadcastComments.h"
#import "iOctocat.h"
#import "CJSONDeserializer.h"


@interface GHBroadcast ()
// Saving
// - (void)setIssueState:(NSString *)theState;
// - (void)toggledIssueStateTo:(id)theResult;
@end


@implementation GHBroadcast

@synthesize user;
@synthesize comments;    
@synthesize body;        
@synthesize created;     
@synthesize track;     
                       
- (NSURL *)resourceURL {                                           
	NSString *urlString = [NSString stringWithFormat:kBroadcastFormat, self.entryID];
	return [NSURL URLWithString:urlString];
}
                          
- (void)parsingJSON:(id)theResult { 
	
	NSDictionary *user = [theResult objectForKey:@"user"];
	[self setByDict:user];
	self.loadingStatus = GHResourceStatusLoaded;      
}                                             


- (void)setByDict:(NSDictionary *)dict{                          
		self.user =[dict objectForKey:@"user"];
		self.body = [dict objectForKey:@"body"];
		self.bio = [dict objectForKey:@"bio"];                                            
		self.created = [self parseDate:[dict objectForKey:@"created_at"]];              
		NSDictionary *trackDict = [dict objectForKey:@"track"];
		self.track = [GHTrack resourceWithDict:trackDict];
}

- (void)loadedGravatar:(UIImage *)theImage {
	[super loadedGravatar:theImage];	
}
										


- (void)dealloc {
    [user release], user = nil;
		[comments release], comments = nil;     
    [body release], body = nil;             
    [created release], created = nil; 
		[track release],track = nil;
		[super dealloc];
}                 
                                        

#pragma mark Saving

- (void)saveData {
	NSString *urlString;
	if (self.isNew) {
		urlString = [NSString stringWithFormat:kOpenIssueXMLFormat, repository.owner, repository.name];
	} else {
		urlString = [NSString stringWithFormat:kEditIssueXMLFormat, repository.owner, repository.name, num];
	}
	NSURL *url = [NSURL URLWithString:urlString];
	NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:title, kIssueTitleParamName, body, kIssueBodyParamName, nil];
	[self saveValues:values withURL:url];
}

- (void)parseSaveData:(NSData *)data {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	GHChannelParserDelegate *parserDelegate = [[GHChannelParserDelegate alloc] initWithTarget:self andSelector:@selector(parsingSaveFinished:)];
	parserDelegate.repository = repository;
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

- (void)parsingSaveFinished:(id)theResult {
	if ([theResult isKindOfClass:[NSError class]]) {
		self.error = theResult;
		self.savingStatus = GHResourceStatusNotSaved;
	} else if ([(NSArray *)theResult count] > 0) {
		GHBroadcast *issue = [(NSArray *)theResult objectAtIndex:0];
		self.user = issue.user;
		self.title = issue.title;
		self.body = issue.body;
		self.state = issue.state;
		self.type = issue.type;
		self.created = issue.created;
		self.updated = issue.updated;
		self.votes = issue.votes;
		self.num = issue.num;
		self.savingStatus = GHResourceStatusSaved;
	}
}

@end
