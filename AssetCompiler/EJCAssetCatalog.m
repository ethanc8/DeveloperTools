#import <Foundation/Foundation.h>
#import "EJCAssetCatalog.h"
#import "EJCColorAsset.h"
#import <AppKit/AppKit.h>

@implementation EJCAssetCatalog
+ (void) load {
    [EJCAsset registerClass: self forAssetType: @"xcassets"];
}
- (instancetype) init {
    self = [super init];
    self.colors = [[NSColorList alloc] initWithName: self.name];
    return self;
}
- (BOOL) isInstallable {
    return YES;
}
// EJCAssetGroup's is slightly modified from this.
- (void) installIntoBundleAtPath: (NSString*)installPath assetCatalog: (EJCAssetCatalog*) catalog error: (NSError**) error {
    for(EJCAsset* child in self.children) {
        if([child.assetType isEqual: @"colorset"]) {
            NSColor* color = [(EJCColorAsset*)child mainColor];
            if(color) {
                [self.colors insertColor: color
                                     key: child.name
                                 atIndex: 0];
            }
        } else if([child isInstallable]) {
            [(id<EJCInstallableAsset>)child installIntoBundleAtPath: installPath assetCatalog: (EJCAssetCatalog*) self error: error];
        }
    }
    NSString* colorListInstallPath = [[[installPath stringByAppendingPathComponent: @"Resources"]
                                                    stringByAppendingPathComponent: self.name]
                                                    stringByAppendingPathExtension: @"clr"];
    [self.colors writeToFile: colorListInstallPath];
}
- (void) dealloc {
    [super dealloc];
    [self.colors release];
}
@end