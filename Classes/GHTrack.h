#import <Foundation/Foundation.h>
#import "GHGravatar.h"         
#import <AudioToolbox/AudioToolbox.h>     
#import <QuartzCore/QuartzCore.h>         
#import "AudioStreamer.h"
#import "Reachability.h"


@class AudioStreamer;
                                               
@interface GHTrack : GHGravatar {
	NSString *name;
	NSString *artist;
	NSString *album;            
	NSURL *streamURL;                
	NSInteger replies;
	NSInteger watchers;             
	AudioStreamer *streamer;
}

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *artist;
@property(nonatomic,retain)NSString *album;           
@property(nonatomic,retain)NSURL *streamURL;
@property(nonatomic,retain)AudioStreamer *streamer;
@property(nonatomic,readwrite)NSInteger replies;
@property(nonatomic,readwrite)NSInteger watchers;

- (int)compareByName:(GHTrack*)theTrack;

@end
