/*
 *  A2ODisplay.m
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <AppKit/A2ODisplay.h>
#import <AppKit/NSScreen.h>
#import <CoreGraphics/A2OWindow.h>

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

-(CGWindow *)windowWithFrame:(NSRect)frame styleMask:(unsigned)styleMask backingType:(unsigned)backingType {
	return [[[A2OWindow alloc] initWithFrame:frame styleMask:styleMask isPanel:NO backingType:backingType] autorelease];
}

-(CGWindow *)panelWithFrame:(NSRect)frame styleMask:(unsigned)styleMask backingType:(unsigned)backingType {
	return [[[A2OWindow alloc] initWithFrame:frame styleMask:styleMask isPanel:YES backingType:backingType] autorelease];
}

-(NSDraggingManager *)draggingManager {
    return nil;
}

@end
