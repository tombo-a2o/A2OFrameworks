/*
 *  EAGL.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSObject.h>

typedef NS_ENUM(NSUInteger, EAGLRenderingAPI) {
    kEAGLRenderingAPIOpenGLES1         = 1,
    kEAGLRenderingAPIOpenGLES2         = 2,
    kEAGLRenderingAPIOpenGLES3         = 3,
};

@interface EAGLSharegroup : NSObject
@end

@interface EAGLContext : NSObject
+(EAGLContext*) currentContext;
+(BOOL)setCurrentContext:(EAGLContext *)context;
-(instancetype)initWithAPI:(EAGLRenderingAPI)api;
-(instancetype)initWithAPI:(EAGLRenderingAPI)api sharegroup:(EAGLSharegroup *)sharegroup;
-(BOOL)presentRenderbuffer:(NSUInteger)target;
@property(readonly) EAGLRenderingAPI API;
@property(readonly) EAGLSharegroup *sharegroup;
@property(copy, nonatomic) NSString *debugLabel;
@property(getter=isMultiThreaded, nonatomic) BOOL multiThreaded;
@end
