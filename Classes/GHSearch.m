#import "GHSearch.h"


@implementation GHSearch

@synthesize results;
@synthesize searchTerm;

+ (id)searchWithURLFormat:(NSString *)theFormat {
	return [[[[self class] alloc] initWithURLFormat:theFormat] autorelease];
}

- (id)initWithURLFormat:(NSString *)theFormat{
	[super init];
	urlFormat = [theFormat retain];
	return self;
}

- (void)dealloc {
	[parserDelegate release], parserDelegate = nil;
	[searchTerm release], searchTerm = nil;
	[urlFormat release], urlFormat = nil;
	[results release], results = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHSearch searchTerm:'%@' resourceURL:'%@'>", searchTerm, self.resourceURL];
}

- (NSURL *)resourceURL {
	NSString *encodedSearchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [iOctocat urlWithFormat:urlFormat, encodedSearchTerm];;
}

- (void)parsingJSON:(id)theResult {
		NSMutableArray *resources = [NSMutableArray array];
		if([theResult objectForKey:@"users"]!=NULL){
			
		  for (NSString *login in [theResult objectForKey:@"users"]) {
				GHUser *theUser = [[iOctocat sharedInstance] userWithLogin:login];
	      [resources addObject:theUser];
	    }
		
		}else	if([theResult objectForKey:@"tracks"]!=NULL){
			for (NSDictionary *tracks in [theResult objectForKey:@"tracks"]) {
				GHRepository *theRepository = [GHRepository repositoryWithDict:tracks];
		    [resources addObject:theRepository];
		  }

		}
		for (GHResource *res in resources) 
			res.loadingStatus = GHResourceStatusNotLoaded;
		self.results = resources;
		self.loadingStatus = GHResourceStatusLoaded;
}

@end
