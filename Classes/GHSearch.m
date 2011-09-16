#import "GHSearch.h"
#import "GHTrack.h"


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
			for (NSDictionary *dict in [theResult objectForKey:@"tracks"]) {
				GHTrack *track = [[GHTrack alloc] initWithDict:dict];
		    [resources addObject:track];
				[track release];
		  }               
		}
		for (GHResource *res in resources) 
			res.loadingStatus = GHResourceStatusNotLoaded;
		self.results = resources;
		self.loadingStatus = GHResourceStatusLoaded;
}

@end
