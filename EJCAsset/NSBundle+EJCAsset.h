#import <Foundation/NSBundle.h>
#import <AppKit/NSImage.h>

@interface NSBundle(EJCAsset)
/** Finds all images with name ``name``, extension [NSImage imageFileTypes], and which
    may contain @1x, @2x, or @3x between the name and the extension. Returns them in an array. */
- (NSArray*) pathsOfImageResource: (NSString*)name;

/** Finds all images with name ``name``, extension [NSImage imageFileTypes], and which
    may contain @1x, @2x, or @3x between the name and the extension. These images are
    then NSImageReps of the returned NSImage. 
    
    To get the paths, use -[NSBundle(EJCAsset) pathsOfImageResource:] */
- (NSImage*) imageForResource: (NSString*)name;
@end