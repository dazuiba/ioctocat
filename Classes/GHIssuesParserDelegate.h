#import <Foundation/Foundation.h>
#import "GHResourcesParserDelegate.h"
#import "GHBroadcast.h"


@interface GHChannelParserDelegate : GHResourcesParserDelegate {
//	GHRepository *repository;
  @private
    GHBroadcast *currentIssue;
}

//@property(nonatomic,retain)GHRepository *repository;

@end
