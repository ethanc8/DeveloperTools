#import <AppKit/AppKit.h>
#import "NSColor+EJCAsset.h"

@implementation NSColor(EJCAsset)
+ (instancetype) colorNamed: (NSString*)colorName bundle: (NSBundle*)bundle catalogName: (NSString*)catalogName {
    NSString* assetCatalogPath = [bundle pathForResource: catalogName ofType: @".clr"];
    NSColorList* colorList = [[NSColorList alloc] initWithName: catalogName fromFile: assetCatalogPath];
    NSColor* color = [colorList colorWithKey: colorName];
    [colorList release];
    return color;
}
+ (instancetype) colorNamed: (NSString*)colorName bundle: (NSBundle*)bundle {
    return [self colorNamed: colorName bundle: bundle catalogName: @"Assets"];
}
+ (instancetype) colorNamed: (NSString*)colorName {
    return [self colorNamed: colorName bundle: NSBundle.mainBundle catalogName: @"Assets"];
}
+ (instancetype) colorWithCatalogName: (NSString*)catalogName colorName:(NSString *)colorName {
    return [self colorNamed: colorName bundle: NSBundle.mainBundle catalogName: catalogName];
}
@end