#import <UIKit/UIKit.h>


@interface GravatarLoader : NSObject {
  @private
	id target;
	SEL handle;
}

- (id)initWithTarget:(id)theTarget andHandle:(SEL)theHandle;
- (void)loadURL:(NSString *)theURL;

@end

