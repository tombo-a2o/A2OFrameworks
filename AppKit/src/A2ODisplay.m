#import <AppKit/A2ODisplay.h>

@implementation NSDisplay(A2O)

+allocWithZone:(NSZone *)zone {
   return NSAllocateObject([A2ODisplay class],0,NULL);
}

@end

@implementation A2ODisplay
-(NSArray *)screens {
   NSRect frame=NSMakeRect(0, 0, 320, 568);
   return [NSArray arrayWithObject:[[[NSScreen alloc] initWithFrame:frame visibleFrame:frame] autorelease]];
}

@end
