#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>     
#import <QuartzCore/QuartzCore.h>         
#import "AudioStreamer.h"
#import "Reachability.h"

@class AudioStreamer;        

@interface MDStreamFile : NSObject {
	NSURL			*filePath;
	NSDictionary	*fileInfoDict;                 
	AudioStreamer *streamer;
	
}                             

@property (nonatomic, retain) NSURL *filePath;
@property (nonatomic, retain) NSDictionary *fileInfoDict;
@property (nonatomic, retain) AudioStreamer *streamer;

+ (NSMutableArray *) arrayWithChannel:(NSString *) channel;
- (NSDictionary *)songID3Tags;
- (NSString *)title;
- (NSString *)artist;
- (NSString *)album;
- (float)duration;
- (NSString *)durationInMinutes;
- (UIImage *)coverImage;       
@end
