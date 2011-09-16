#import "GHGravatar.h"
#import "GravatarLoader.h"


@implementation GHGravatar

@synthesize avatarPath;
@synthesize gravatar;
@synthesize gravatarLoader;


- (id)init {
	[super init];
	gravatarLoader = [[GravatarLoader alloc] initWithTarget:self andHandle:@selector(loadedGravatar:)];
	return self;
}                                    

- (void)setByDict:(NSDictionary *)dict{     
	[self setAvatarAndLoad:[dict objectForKey:@"avatar"]];
}


#pragma mark Gravatar
- (void)setAvatarAndLoad:(NSString *)urlString{  
	if(urlString){
		self.avatarPath = urlString;                                 
	  [self.gravatarLoader loadURL:self.avatarPath];     
	} 
}
- (void)loadedGravatar:(UIImage *)theImage {
	self.gravatar = theImage;
	[UIImagePNGRepresentation(theImage) writeToFile:self.cachedGravatarPath atomically:YES];
	DJLog(@"end");
}


- (NSInteger)gravatarSize {
	UIScreen *mainScreen = [UIScreen mainScreen];
	CGFloat deviceScale = ([mainScreen respondsToSelector:@selector(scale)]) ? [mainScreen scale] : 1.0;
	NSInteger size = kImageGravatarMaxLogicalSize * MAX(deviceScale, 1.0);
	return size;
}                                                         

- (void)dealloc {
	[self.avatarPath release];       
	[self.gravatar release];
	[self.gravatarLoader release];
	[self.gravatar release];            
}

- (NSString *)cachedGravatarPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
  id *uniqID = NULL;
	if ([NSStringFromClass([self class]) isEqualToString:@"GHUser"]) {
		uniqID = [self valueForKey:@"login"];
	}else {
		uniqID = [NSString stringWithFormat:@"%d",[self valueForKey:@"entryID"]];
	}

	NSString *imageName = [NSString stringWithFormat:@"%@--%@.png", NSStringFromClass([self class]),uniqID];
	DJLog(@"%@",imageName);
	return [documentsPath stringByAppendingPathComponent:imageName];
}

@end
