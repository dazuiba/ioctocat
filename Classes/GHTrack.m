#import "GHTrack.h"
#import "iOctocat.h"

@implementation GHTrack

@synthesize name;   
@synthesize artist;
@synthesize album;
@synthesize streamURL; 
@synthesize streamer;
@synthesize replies;
@synthesize watchers;            
                         
- (void)dealloc {
	[name release];
	[artist release];
	[album release];
	[streamURL release];      
  [super dealloc];
}                                                      

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHTrack name:'%@' streamURL:'%@'>", name, streamURL];
}                                      

- (void)setByDict:(NSDictionary *)dict{
	[super setByDict:dict];
	self.name = [dict objectForKey:@"name"];
	self.streamURL = [NSURL URLWithString:[dict objectForKey:@"stream"]];
	NSDictionary *albumDict = [dict objectForKey:@"album"];
	[self setAvatarAndLoad:[albumDict objectForKey:@"image_url"]];
}         

@end
