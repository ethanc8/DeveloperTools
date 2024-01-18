#import <Foundation/Foundation.h>
#import "EJCAsset.h"
#import "EJCErrorLog.h"

int EJCMain() {
    NSArray* arguments = [[NSProcessInfo processInfo] arguments];
    BOOL isFirstArgument = YES;
    NSMutableArray* assetCatalogs = [NSMutableArray array];
    NSError* error = nil;
    NSString* workingDirectory = NSFileManager.defaultManager.currentDirectoryPath;
    NSString* outputBundle = @"";

    BOOL isOutputBundle = NO;
    for(NSString* argument in arguments) {
        if(isFirstArgument) {
            isFirstArgument = NO;
        } else if(isOutputBundle) {
            outputBundle = argument;
            isOutputBundle = NO;
        } else if([argument characterAtIndex:0] != u'-') {
            [assetCatalogs addObject: [[EJCAsset alloc] initAtPath: argument error: &error]];
            EJC_LOG_IF_NSERROR(error, @"Error parsing asset at path %@", argument);
        } else if([argument isEqual: @"--outBundle"]) {
            isOutputBundle = YES;
        }
    }
    NSLog(@"%@", assetCatalogs);
    for(EJCAsset* assetCatalog in assetCatalogs) {
        NSLog(@"%@", assetCatalog.children);
        [(id<EJCInstallableAsset>)assetCatalog installIntoBundleAtPath: outputBundle 
                                                          assetCatalog: nil
                                                                 error: &error];
        // for(EJCAsset* asset in assetCatalog.children) {
        //     if([asset isInstallable]) {
        //         NSLog(@"Asset is installable");
        //         [(id<EJCInstallableAsset>)asset installIntoBundleAtPath: 
        //             [workingDirectory stringByAppendingPathComponent: @"Tests/out/out.bundle"] error: &error];
        //         EJC_LOG_IF_NSERROR(error, @"Error installing asset at path %@", asset.path);
        //     } else {
        //         NSLog(@"Asset is not installable");
        //     }
        // }
    }
    return 0;
}

int main(int argc, char* argv[]) {
    @autoreleasepool {
        return EJCMain();
    }
}