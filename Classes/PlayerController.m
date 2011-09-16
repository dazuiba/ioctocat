//
//  PlayerController.m
//  iOctocat
//
//  Created by sam on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayerController.h"


@implementation PlayerController
@synthesize track;
- (PlayerController *)init{
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


                 
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{   DJLog(@"progress: %f",streamer.progress);
		progressView.progress = streamer.progress/100.0;
		/*
         if ([durationLabel.text isEqualToString:@""]) {
         int duration = [[NSString stringWithFormat:@"%.0f", streamer.duration] intValue];
         durationLabel.text = [NSString stringWithFormat:@"%d:%02d", duration/60, duration%60];
         }
         */
	}
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
	DJLog(@"%@", [track streamURL]); 
	streamer = [[AudioStreamer alloc] initWithURL:[track streamURL]];
	
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
			timer =
			[NSTimer
			 scheduledTimerWithTimeInterval:1.0
			 target:self
			 selector:@selector(updateProgress:)
			 userInfo:nil
			 repeats:YES];    
		}
	}
	else {
		if (timer)
		{
			[timer invalidate];
			timer = nil;
		}
	}
}

- (void)playBackStateChanged:(NSNotification *)notification {
	// 歌曲加载中
	if ([streamer isWaiting]) {
		DJLog(@"i am waiting");
	} 
	// 歌曲播放中
	else if ([streamer isPlaying]) {
		DJLog(@"i am playing"); 
	} 
	// 歌曲暂停中
	else if ([streamer isPaused]) {
		DJLog(@"i am paused");
	} 
	// 歌曲停止
	else if ([streamer isIdle]) {
		DJLog(@"i am idled");
		[self destroyStreamer];

	}
	DJLog(@"errorCode: %d", streamer.errorCode);
}                       

@end
