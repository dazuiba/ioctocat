#import <Foundation/Foundation.h>
#import "GHResource.h"
#import "GHBroadcast.h"


@interface GHChannel : GHResource {
	NSArray *entries;
  @private
	NSString *issueState;
}

@property(nonatomic,retain)NSArray *entries;
@property(nonatomic,retain)NSString *issueState;


@end
