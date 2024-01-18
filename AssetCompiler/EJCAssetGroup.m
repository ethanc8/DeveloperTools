#import <Foundation/Foundation.h>
#import "EJCAssetGroup.h"
#import "EJCAssetCatalog.h"
#import "EJCColorAsset.h"
#import "EJCErrorLog.h"
#import <AppKit/AppKit.h>

static NSFileManager* defaultNSFileManager;

@implementation EJCAssetGroup
+ (void) load {
    [EJCAsset registerClass: self forAssetType: @""];
    defaultNSFileManager = [NSFileManager defaultManager];
}
- (instancetype) init {
    self = [super init];
    self.colors = [[NSColorList alloc] initWithName: self.name];
    self.providesNamespace = [self.contents[@"properties"][@"provides-namespace"] boolValue];
    return self;
}
- (BOOL) isInstallable {
    return YES;
}
// EJCAssetCatalog's is slightly modified from this.
- (void) installIntoBundleAtPath: (NSString*)installPath assetCatalog: (EJCAssetCatalog*) catalog error: (NSError**) error {
    for(EJCAsset* child in self.children) {
        if([child.assetType isEqual: @"colorset"]) {
            NSColor* color = [(EJCColorAsset*)child mainColor];
            if(color) {
                [catalog.colors insertColor: color
                                     key: child.name
                                 atIndex: 0];
            }
        } else if([child isInstallable]) {
            [(id<EJCInstallableAsset>)child installIntoBundleAtPath: installPath assetCatalog: (EJCAssetCatalog*) catalog error: error];
        }
    }
}
// Modified from EJCAsset.
- (NSArray<EJCAsset*>*) children {
    if(self->_children == nil && self.path != nil) {
        NSMutableArray<EJCAsset*>* children = [NSMutableArray array];
        NSString* path = self.path;
        NSError* error = nil;
        NSArray<NSString*>* childSubpaths = [defaultNSFileManager contentsOfDirectoryAtPath: path error: &error];
        EJC_LOG_IF_NSERROR(error, @"Error enumerating contents of directory %@", path);
        for(NSString* childSubpath in childSubpaths) {
            NSString* childPath = [path stringByAppendingPathComponent: childSubpath];
            BOOL isDirectory;
            if([defaultNSFileManager fileExistsAtPath: childPath isDirectory: &isDirectory] && isDirectory) { 
                EJCAsset* child = [[EJCAsset alloc] initAtPath: childPath error: &error];
                // Here's the change!
                // If we provide the namespace, we must add the our name before the child's name.
                if(self.providesNamespace) child.name = [self.name stringByAppendingPathComponent: child.name];
                [children addObject: child];
                EJC_LOG_IF_NSERROR(error, @"Error parsing asset at path %@", childPath);
            }
        }
        self->_children = children;
        return children;
    } else {
        return self->_children;
    }
}
- (void) setChildren: (NSArray<EJCAsset*>*)children {
    self->_children = [children retain];
}
- (void) dealloc {
    [super dealloc];
    [self.colors release];
}
@end