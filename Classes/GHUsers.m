#import "GHUsers.h"
#import "GHUser.h"
#import "iOctocat.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"


@implementation GHUsers

@synthesize user, users;

- (id)initWithUser:(GHUser *)theUser andURL:(NSURL *)theURL {
    [super init];
    self.user = theUser;
	self.users = [NSMutableArray array];
    self.resourceURL = theURL;
	return self;    
}

- (void)dealloc {
	[user release];
	[users release];
  [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHUsers user:'%@' resourceURL:'%@'>", user, resourceURL];
}
 

- (void)parsingJSON:(id)theResult {
		// [theResult sortUsingSelector:@selector(compareByName:)];
	 NSMutableArray *resources = [NSMutableArray array];
	 for (NSString *login in [theResult objectForKey:@"users"]) {
			GHUser *theUser = [[iOctocat sharedInstance] userWithLogin:login];
      [resources addObject:theUser];
   }
	 self.users = resources;
	 self.loadingStatus = GHResourceStatusLoaded;
}

@end
