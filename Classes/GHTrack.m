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
	self.streamURL =[dict objectForKey:@"stream"];
	NSDictionary *albumDict = [dict objectForKey:@"album"];
	[self setAvatarAndLoad:[albumDict objectForKey:@"image_url"]];
}




#pragma mark streamfile

                           
- (void)play {     
	if (streamer) {
		[self destroyStreamer];
	}
	                              
	[self createStreamer: self.streamURL];
	[streamer start];       
}
                        


// 创建流播放器
- (void)createStreamer:(NSURL *)theURL {
	if (streamer) {
		return;
	}
	[self destroyStreamer];                              
	streamer = [[AudioStreamer alloc] initWithURL:theURL];      
}         


// 销毁流播放器
- (void)destroyStreamer {
	if (streamer) {
		[[NSNotificationCenter defaultCenter] 
		 removeObserver:self 
		 name:ASStatusChangedNotification 
		 object:streamer];
		
		[self createTimers:NO];
		
		[streamer stop];
		[streamer release];
		streamer = NULL;
	}
}                         

@end
