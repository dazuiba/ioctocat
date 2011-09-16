#import <Foundation/Foundation.h>
#import "GHResource.h"


@class GHBroadcastComments, GHTrack;

@interface GHBroadcast : GHResource{
	GHBroadcastComments *comments;
	NSString *user;                 
	NSString *body;                
	NSDate *created;               
	GHTrack *track;        
}
                                                           
@property(nonatomic,retain)GHBroadcastComments *comments;
@property(nonatomic,retain)NSString *user;
@property(nonatomic,retain)NSString *body;
@property(nonatomic,retain)NSDate *created;
@property(nonatomic,retain)GHTrack *track;

- (void)saveData;

@end
