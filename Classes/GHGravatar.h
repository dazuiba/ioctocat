#import <Foundation/Foundation.h>
#import "GHResource.h"

@class GravatarLoader;

@interface GHGravatar : GHResource {
	
	NSString *avatarPath;
	UIImage *gravatar;
	@private
	GravatarLoader *gravatarLoader;

}

@property(nonatomic,retain)NSString *avatarPath;
@property(nonatomic,retain)UIImage *gravatar;
@property(nonatomic,readonly)NSString *cachedGravatarPath;
@property(nonatomic,retain)GravatarLoader *gravatarLoader;
- (void)loadedGravatar:(UIImage *)theImage;

@end
