#import <Foundation/Foundation.h>
#import "EJCColorAsset.h"
#import "EJCAssetCatalog.h"

@implementation EJCColorAsset
+ (void) load {
    [EJCAsset registerClass: self forAssetType: @"colorset"];
}
- (NSColor*) mainColor {
    NSArray* colors = self.contents[@"colors"];
    for(NSDictionary* color in colors) {
        // TODO - Support non-sRGB colorspaces
        // TODO - Support more than one version of a color
        if([color[@"idiom"] isEqual: @"universal"]
        && ![color objectForKey: @"appearances"] 
        && [color[@"color"][@"color-space"] isEqual: @"srgb"]) {
            return [EJCColorAsset colorForColorDictionary: color];
        }
    }
    NSWarnMLog(@"Could not find main color for color set with colors: %@", colors);
    return nil;
}
+ (NSColor*) colorForColorDictionary: (NSDictionary*) dictionary {
    NSDictionary* colorInfo = dictionary[@"color"];
    if([colorInfo[@"color-space"] isEqual: @"srgb"]) {
        return [NSColor colorWithSRGBRed: (CGFloat)[colorInfo[@"red"] doubleValue] 
                                   green: (CGFloat)[colorInfo[@"green"] doubleValue] 
                                    blue: (CGFloat)[colorInfo[@"blue"] doubleValue] 
                                   alpha: (CGFloat)[colorInfo[@"alpha"] doubleValue]];
    } else {
        NSWarnMLog(@"Could not parse color for color dictionary: %@", dictionary);
        return nil;
    }
}
- (BOOL) isInstallable {
    return YES;
}
- (void) installIntoBundleAtPath: (NSString*)installPath assetCatalog: (EJCAssetCatalog*) catalog error: (NSError**) error {
    NSColor* color = [(EJCColorAsset*)self mainColor];
    if(color) {
        [catalog.colors insertColor: color
                                key: self.name
                            atIndex: 0];
    }
}
@end

