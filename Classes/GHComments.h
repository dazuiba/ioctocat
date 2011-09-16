#import <Foundation/Foundation.h>
#import "GHResource.h"


@class GHBroadcast;

@interface GHComments : GHResource {
	NSMutableArray *comments;
	GHUser *user;
	GHBroadcast *issue;
}

@property(nonatomic,retain)NSMutableArray *comments;
@property(nonatomic,retain)GHBroadcast *issue;
@property(nonatomic,retain)GHBroadcast *user;

+ (id)commentsWithIssue:(GHBroadcast *)theIssue;
- (id)initWithIssue:(GHBroadcast *)theIssue;

@end
