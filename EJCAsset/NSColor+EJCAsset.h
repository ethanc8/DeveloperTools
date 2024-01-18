#import <AppKit/NSColor.h>

@class NSString;
@class NSBundle;

@interface NSColor(EJCAsset)
/** Finds the color named ``colorName`` in the ``bundle`` bundle, in the asset catalog ``catalogName``.xcassets.
    Currently, this should be stored as a file named ``catalogName``.clr. */
+ (instancetype) colorNamed: (NSString*)colorName bundle: (NSBundle*)bundle catalogName: (NSString*)catalogName;
/** Finds the color named ``colorName`` in the ``bundle`` bundle, in the asset catalog Assets.xcassets.
    Currently, this should be stored as a file named Assets.clr. */
+ (instancetype) colorNamed: (NSString*)colorName bundle: (NSBundle*)bundle;
/** Finds the color named ``colorName`` in the app's main bundle, in the asset catalog Assets.xcassets.
    Currently, this should be stored as a file named Assets.clr. */
+ (instancetype) colorNamed: (NSString*)colorName;
/** Finds the color named ``colorName`` in the app's main bundle, in the asset catalog ``catalogName``.xcassets.
    Currently, this should be stored as a file named ``catalogName``.clr. */
+ (instancetype) colorWithCatalogName: (NSString*)catalogName colorName:(NSString *)colorName;
@end