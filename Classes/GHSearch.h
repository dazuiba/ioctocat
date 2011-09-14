#import <Foundation/Foundation.h>
#import "GHResourcesParserDelegate.h"
#import "GHResource.h"
#import "iOctocat.h"


@interface GHSearch : GHResource {
	NSArray *results;
	@private
	NSString *urlFormat;
	NSString *searchTerm;
	GHResourcesParserDelegate *parserDelegate;
}

@property(nonatomic,retain)NSArray *results;
@property(nonatomic,retain)NSString *searchTerm;

+ (id)searchWithURLFormat:(NSString *)theUrlFormat;
- (id)initWithURLFormat:(NSString *)theUrlFormat;

@end


