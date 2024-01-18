#import "EJCAsset.h"
#import <AppKit/NSColor.h>

@interface EJCColorAsset: EJCAsset
- (NSColor*) mainColor;
+ (NSColor*) colorForColorDictionary: (NSDictionary*) dictionary;
@end