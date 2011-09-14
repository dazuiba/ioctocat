#import <Foundation/Foundation.h>
#import "GHGravatar.h"
#import "GHUser.h"
#import "GHFeed.h"


@class GHIssues, GHNetworks, GHBranches;

@interface GHRepository : GHGravatar {
	NSInteger entryID;
	NSString *name;
	NSString *owner;
	NSString *descriptionText;
	NSURL *streamURL;
	NSURL *homepageURL;
	NSInteger replies;
	NSInteger watchers;
  GHIssues *openIssues;
  GHIssues *closedIssues;
  GHNetworks *networks;
  GHBranches *branches;
	BOOL isPrivate;
	BOOL isFork;
}

@property(nonatomic,readwrite)NSInteger entryID;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *owner;
@property(nonatomic,retain)NSString *descriptionText;
@property(nonatomic,retain)NSURL *streamURL;
@property(nonatomic,retain)NSURL *homepageURL;
@property(nonatomic,retain)GHIssues *openIssues;
@property(nonatomic,retain)GHIssues *closedIssues;
@property(nonatomic,retain)GHNetworks *networks;
@property(nonatomic,retain)GHBranches *branches;
@property(nonatomic,readonly)GHUser *user;
@property(nonatomic,readwrite)NSInteger replies;
@property(nonatomic,readwrite)NSInteger watchers;
@property(nonatomic,readwrite)BOOL isPrivate;
@property(nonatomic,readwrite)BOOL isFork;

+ (id)repositoryWithOwner:(NSString *)theOwner andName:(NSString *)theName;
+ (id)repositoryWithDict:(NSDictionary *)dict;

- (id)initWithOwner:(NSString *)theOwner andName:(NSString *)theName;
- (void)setOwner:(NSString *)theOwner andName:(NSString *)theName;
- (int)compareByName:(GHRepository*)repo;

@end
