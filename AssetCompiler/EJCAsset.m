#import "EJCAsset.h"
#import "EJCErrorLog.h"

static NSFileManager* defaultNSFileManager;
static NSMutableDictionary* classForAssetType;
static NSMutableDictionary* assetTypeForFileExtension;

@implementation EJCAsset: NSObject

+ (void) load {
    defaultNSFileManager = [NSFileManager defaultManager];
    classForAssetType = [NSMutableDictionary dictionary];
    assetTypeForFileExtension = [NSMutableDictionary dictionary];
}

- (instancetype) initWithContentsDictionary: (NSDictionary*)contentsDictionary {
    self = [super init];
    self.contents = contentsDictionary;
    return [self init];
}
- (instancetype) initAtPath: (NSString*)path error: (NSError**)error {
    Class instanceClass = [EJCAsset classForAssetType: path.pathExtension];
    NSLog(@"Using class %@ for asset at path %@", instanceClass, path);
    if(instanceClass != [self class]) {
        return [[instanceClass alloc] initAtPath: path error: error];
    }
    return [self _initAtPath: (NSString*)path error: (NSError**)error];
}
- (instancetype) _initAtPath: (NSString*)path error: (NSError**)error {
    self.path = path;
    self.assetType = path.pathExtension;
    NSUInteger extensionLength = (self.assetType.length ?: -1) + 1;
    self.name = [[path substringToIndex: path.length - extensionLength] lastPathComponent];
    return [self initWithData: 
        [NSData dataWithContentsOfFile: 
            [path stringByAppendingString: @"/Contents.json"]] 
                        error: error];
}
- (instancetype) initWithData: (NSData*)data error: (NSError**)error {
    self = [super init];
    self.contents = [NSJSONSerialization JSONObjectWithData: data options: 0 error: error];
    return [self init];
}
- (instancetype) init {
    self.children = nil;
    return self;
}
// EJCAssetGroup modifies this.
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
                [children addObject: [[EJCAsset alloc] initAtPath: childPath error: &error]];
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
- (instancetype) assetWithAssetType: (NSString *)assetType {
    EJCAsset* newSelf =  [[[classForAssetType[assetType] alloc] init] autorelease];
    newSelf.assetType = assetType;
    newSelf.children = self.children;
    newSelf.contents = self.contents;
    newSelf.path = self.path;
    return newSelf;
}
+ (Class) classForAssetType: (NSString *)assetType {
    return classForAssetType[assetType] ?: self;
}
+ (void) registerClass:(Class)class forAssetType:(NSString *)assetType {
    // NSLog(@"Registering class %@ for type %@", class, assetType);
    classForAssetType[assetType] = class;
}
// - (NSString*) description {
//     return [NSString stringWithFormat: @"\n<EJCAsset{\"%@\"}\n    at %@\n    contents: %@\n    children: %@\n>",
//             self.assetType, self.path, self.contents, self.children];
// }
- (BOOL) isInstallable {
    return NO;
}
@end