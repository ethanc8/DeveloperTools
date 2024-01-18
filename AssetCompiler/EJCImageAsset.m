#import <Foundation/Foundation.h>
#import "EJCImageAsset.h"

@implementation EJCImageAsset
+ (void) load {
    [EJCAsset registerClass: self forAssetType: @"imageset"];
}
- (BOOL) isInstallable {
    return YES;
}
- (void) installIntoBundleAtPath: (NSString*)installPath assetCatalog: (EJCAssetCatalog*) catalog error: (NSError**) error {
    NSArray* images = self.contents[@"images"];
    NSString* resourceDirectory = [installPath stringByAppendingPathComponent:@"Resources"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    for(NSDictionary* image in images) {
        NSString* filename = image[@"filename"];
        if(filename) {
            // NSString* extension = [filename pathExtension];
            // NSString* name = [[filename substringToIndex: filename.length - extension.length - 1] lastPathComponent];
            [fileManager copyItemAtPath: [self.path stringByAppendingPathComponent: filename] 
                                 toPath: [resourceDirectory stringByAppendingPathComponent: filename] 
                                  error: error];
            NSLog(@"Copying %@ to %@...", [self.path stringByAppendingPathComponent: filename], resourceDirectory);
        }
    }
}
@end