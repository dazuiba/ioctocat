#import <UIKit/UIKit.h>
#import "GHGravatar.h"
#import "GHUsers.h"
#import "GHRepositories.h"


@class GravatarLoader, GHRepository, GHFeed;

@interface GHUser : GHGravatar {
	NSUInteger entryID; 
	NSString *name;
	NSString *login;
	NSString *email;
	NSString *bio;
	NSString *location;
	NSString *searchTerm;
	NSString *createdAt;
	NSUInteger broadcastCount;
	NSUInteger favoritesCount; 
	GHFeed *recentActivity;
  GHUsers *following;
  GHUsers *followers;
	BOOL isAuthenticated;
}

@property(nonatomic)NSUInteger entryID;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *login;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *bio;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain)NSString *createdAt;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSString *searchTerm;
@property(nonatomic,retain)GHFeed *recentActivity;
@property(nonatomic,retain)GHUsers *following;
@property(nonatomic,retain)GHUsers *followers;
@property(nonatomic)BOOL isAuthenticated;
@property(nonatomic)NSUInteger broadcastCount;
@property(nonatomic)NSUInteger favoritesCount;

+ (id)user;
+ (id)userForSearchTerm:(NSString *)theSearchTerm;
+ (id)userWithLogin:(NSString *)theLogin;
+ (id)userWithDict:(NSDictionary *)attributes;
- (BOOL)isAuthenticated;
- (id)initWithLogin:(NSString *)theLogin;
- (void)setLogin:(NSString *)theLogin;
- (void)loadUser;
- (void)loadedUsers:(id)theResult;
- (BOOL)isFollowing:(GHUser *)anUser;
- (BOOL)isWatching:(GHRepository *)aRepository;
- (void)followUser:(GHUser *)theUser;
- (void)unfollowUser:(GHUser *)theUser;

@end
