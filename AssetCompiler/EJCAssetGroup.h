#import "EJCAsset.h"
#import <AppKit/NSColorList.h>

@interface EJCAssetGroup: EJCAsset <EJCInstallableAsset>
@property(retain) NSColorList* colors;
@property BOOL providesNamespace;
@end