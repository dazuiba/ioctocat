//
//  PlayerController.h
//  iOctocat
//
//  Created by sam on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>     
#import "AudioStreamer.h"
#import "Reachability.h"       
#import <QuartzCore/QuartzCore.h>     
@class GHTrack, AudioStreamer;
@interface PlayerController : UIViewController {
	GHTrack		*track;         
	IBOutlet UILabel *trackLabel;
	IBOutlet UILabel *trackLabelAnimation;
	IBOutlet UILabel *albumLabel;
	IBOutlet UILabel *progressLabel;
	
	IBOutlet UIImageView *albumImageView;           
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *nextButton;
	IBOutlet UIButton *shareButton;         
	NSTimer *timer;                 
	AudioStreamer *streamer;
	
}
                            
@property (nonatomic, retain) GHTrack *track;         
@property (nonatomic, retain)AudioStreamer *streamer;
- (IBAction)playButtonPressed;
- (IBAction)nextButtonPressed;
- (IBAction)shareButtonPressed;

@end
