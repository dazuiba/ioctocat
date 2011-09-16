#import <UIKit/UIKit.h>
#import "LoginController.h"
#import "PlayerController.h"
#import "MyFeedsController.h"
#import "GHUser.h"
#import "ASINetworkQueue.h"

@class GHTrack, PlayerController;
@interface iOctocat : NSObject <UIApplicationDelegate, UIActionSheetDelegate> {
  @private
  IBOutlet UIWindow *window;
  IBOutlet UITabBarController *tabBarController;
	IBOutlet UIView *authView;
	IBOutlet MyFeedsController *feedController;
	UIActionSheet *authSheet;
	NSMutableDictionary *users;
	NSDate *didBecomeActiveDate;
	BOOL launchDefault;
}

@property(nonatomic,retain)NSMutableDictionary *users;
@property(nonatomic,retain)NSDate *didBecomeActiveDate;
@property(nonatomic,readonly)LoginController *loginController;

+ (NSURL *)urlWithFormat:(NSString *)format, ...;
+ (ASINetworkQueue *)queue;
+ (iOctocat *)sharedInstance;
+ (NSDate *)parseDate:(NSString *)theString;
- (GHUser *)currentUser;
- (UIView *)currentView;
- (GHUser *)userWithLogin:(NSString *)theUsername;
- (NSDate *)lastReadingDateForURL:(NSURL *)url;
- (void)presentPlayer:(GHTrack *)track;
- (void)setLastReadingDate:(NSDate *)date forURL:(NSURL *)url;

@end

