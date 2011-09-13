#import <UIKit/UIKit.h>
#import "GHResource.h"
#import "GHUsers.h"
#import "GHRepositories.h"


@class GravatarLoader, GHRepository, GHFeed;

@interface GHUser : GHResource {
	NSString *name;
	NSString *login;
	NSString *email;
	NSString *bio;
	NSString *location;
	NSString *avatarPath;
	NSString *searchTerm;
	UIImage *gravatar;
	NSString *createdAt;
	NSUInteger listenersCount;
	NSUInteger favoritesCount;
	GHFeed *recentActivity;
  GHUsers *following;
  GHUsers *followers;
	BOOL isAuthenticated;
  @private
	GravatarLoader *gravatarLoader;
}

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *login;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *bio;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,retain)NSString *createdAt;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSString *searchTerm;
@property(nonatomic,retain)NSString *avatarPath;
@property(nonatomic,retain)UIImage *gravatar;
@property(nonatomic,retain)GHFeed *recentActivity;
@property(nonatomic,retain)GHUsers *following;
@property(nonatomic,retain)GHUsers *followers;
@property(nonatomic,readonly)NSString *cachedGravatarPath;
@property(nonatomic)BOOL isAuthenticated;
@property(nonatomic)NSUInteger listenersCount;
@property(nonatomic)NSUInteger favoritesCount;

+ (id)user;
+ (id)userForSearchTerm:(NSString *)theSearchTerm;
+ (id)userWithLogin:(NSString *)theLogin;
- (id)initWithLogin:(NSString *)theLogin;
- (void)setLogin:(NSString *)theLogin;
- (void)loadUser;
- (void)loadedUsers:(id)theResult;
- (void)loadedGravatar:(UIImage *)theImage;
- (BOOL)isFollowing:(GHUser *)anUser;
- (BOOL)isWatching:(GHRepository *)aRepository;
- (void)followUser:(GHUser *)theUser;
- (void)unfollowUser:(GHUser *)theUser;

@end
