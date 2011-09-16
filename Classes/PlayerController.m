//
//  PlayerController.m
//  iOctocat
//
//  Created by sam on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayerController.h"


@implementation PlayerController
@synthesize tracks;
- (id)initWithTarget:(id)theTarget andSelector:(SEL)theSelector {
	[super initWithNibName:@"Player" bundle:nil];
	return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}
                     

- (void)viewDidAppear:(BOOL)animated {
	
} 

- (void)dealloc {               
	[self destroyStreamer];
	[self createTimers:NO];         
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}                    


                 
                     

#pragma mark Streamer

- (void)play {    
	if (streamer) {
		[self destroyStreamer];
	}                                           	                                            
	// 播放
	[self createStreamer:[self.track streamURL]];
	[streamer start];                           
}

                   
- (void)createStreamer:(NSString *)urlString {
	if (streamer) {
		return;
	}
	[self destroyStreamer];
	//NSLog(@"%@", urlString);
	NSString *escapedValue = [(NSString *)CFURLCreateStringByAddingPercentEscapes(
																				  nil, 
																				  (CFStringRef)urlString, 
																				  NULL, 
																				  NULL, 
																				  kCFStringEncodingUTF8)
							  autorelease];
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	[self createTimers:YES];
	
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(playBackStateChanged:)
	 name:ASStatusChangedNotification 
	 object:streamer];
}                         

- (void)destroyStreamer {
	if (streamer) {
		[[NSNotificationCenter defaultCenter] 
		 removeObserver:self 
		 name:ASStatusChangedNotification 
		 object:streamer];
		
		[self createTimers:NO];
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}




//　新建/销毁歌曲时间计时器
-(void)createTimers:(BOOL)create {
	if (create) {
		if (streamer) {
			[self createTimers:NO];
			progressUpdateTimer =
			[NSTimer
			 scheduledTimerWithTimeInterval:1.0
			 target:self
			 selector:@selector(updateProgress:)
			 userInfo:nil
			 repeats:YES];
		}
	}
	else {
		if (progressUpdateTimer)
		{
			[progressUpdateTimer invalidate];
			progressUpdateTimer = nil;
		}
	}
}

@end
