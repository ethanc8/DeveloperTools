#import "EJCAsset.h"
#import <AppKit/NSColorList.h>

@interface EJCAssetCatalog: EJCAsset <EJCInstallableAsset>
@property(retain) NSColorList* colors;
@end