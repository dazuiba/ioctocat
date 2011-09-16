#import <Foundation/Foundation.h>
#import "GHResource.h"


@class GHBroadcast, GHUser;

@interface GHBroadcastComment : GHResource {
	GHBroadcast *issue;
	GHUser *user;
	NSUInteger commentID;
	NSString *body;
	NSDate *created;
	NSDate *updated;
}

@property(nonatomic,retain)GHBroadcast *issue;
@property(nonatomic,retain)GHUser *user;
@property(nonatomic,assign)NSUInteger commentID;
@property(nonatomic,retain)NSString *body;
@property(nonatomic,retain)NSDate *created;
@property(nonatomic,retain)NSDate *updated;

- (id)initWithIssue:(GHBroadcast *)theIssue andDictionary:(NSDictionary *)theDict;
- (id)initWithIssue:(GHBroadcast *)theIssue;
- (void)saveData;

@end
