#import <Foundation/NSBundle.h>
#import <AppKit/NSImage.h>
#import "NSBundle+EJCAsset.h"

@implementation NSBundle(EJCAsset)
/** Finds all images with name ``name``, extension [NSImage imageFileTypes], and which
    may contain @1x, @2x, or @3x between the name and the extension. Returns them in an array. */
- (NSArray*) pathsOfImageResource: (NSString*)name {
    NSArray* imageFileTypes = [NSImage imageFileTypes];
    NSMutableArray* paths = [NSMutableArray array];

    #define ADD_OBJECT_IF_NON_NIL(array, object) do {\
        id theObject = object; \
        if(theObject) \
            [array addObject: theObject]; \
    } while(0)

    for(NSString* fileType in imageFileTypes) {
        ADD_OBJECT_IF_NON_NIL(paths, [self pathForResource: name ofType: fileType]);
        ADD_OBJECT_IF_NON_NIL(paths, [self pathForResource: [name stringByAppendingString: @"@1x"] ofType: fileType]);
        ADD_OBJECT_IF_NON_NIL(paths, [self pathForResource: [name stringByAppendingString: @"@2x"] ofType: fileType]);
        ADD_OBJECT_IF_NON_NIL(paths, [self pathForResource: [name stringByAppendingString: @"@3x"] ofType: fileType]);
    }

    return paths;
}

/** Finds all images with name ``name``, extension [NSImage imageFileTypes], and which
    may contain @1x, @2x, or @3x between the name and the extension. These images are
    then NSImageReps of the returned NSImage. 
    
    To get the paths, use -[NSBundle(GNUstep) pathsOfImageResource:] */
- (NSImage*) imageForResource: (NSString*)name {
    NSArray* paths = [self pathsOfImageResource: name];
    NSImage* image = [[NSImage alloc] initWithSize: (NSSize){.height = 0, .width = 0}];
    NSImageRep* rep1x = nil;
    for(NSString* path in paths) {
        NSImageRep* imageRep = [NSImageRep imageRepWithContentsOfFile: path];
        [image addRepresentation: imageRep];
        if(rep1x == nil
        && ![path containsString: @"@2x."] 
        && ![path containsString: @"@3x."]) 
            rep1x = imageRep;
    }
    [image setSize: (NSSize){.height = [rep1x pixelsHigh], .width = [rep1x pixelsWide]}];
    return image;
}
@end