#import <Foundation/Foundation.h>

@class EJCAssetCatalog;

@interface EJCAsset: NSObject {
    NSString* _path;
    NSArray <EJCAsset*>* _children;
}

- (instancetype) initWithContentsDictionary: (NSDictionary*)contentsDictionary;
- (instancetype) initAtPath: (NSString*)path error: (NSError**)error;
/// Same as above, but does not automatically detect subclass based on file extension.
/// Should only be used in implementations of subclass initAtPath:error:
- (instancetype) _initAtPath: (NSString*)path error: (NSError**)error;
- (instancetype) initWithData: (NSData*)data error: (NSError**)error;

@property(retain) NSDictionary* contents;
@property(retain) NSArray <EJCAsset*>* children;
@property(retain) NSString* path;
@property(retain) NSString* name;

@property(retain) NSString* assetType;

- (instancetype) assetWithAssetType: (NSString*)assetType;
+ (void) registerClass: (Class)class forAssetType: (NSString*)assetType;
+ (Class) classForAssetType: (NSString*)assetType;

@property(readonly) BOOL isInstallable;
@end

@protocol EJCInstallableAsset
@required
- (void) installIntoBundleAtPath: (NSString*)installPath assetCatalog: (EJCAssetCatalog*) catalog error: (NSError**) error; 
@end