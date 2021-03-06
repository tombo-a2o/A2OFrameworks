/*
 *  O2Exceptions.h
 *  A2OFrameworks
 *
 *  Copyright (c) 2014- Tombo Inc.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#import <Foundation/NSException.h>
#import <Foundation/NSString.h>

static inline void _KGInvalidAbstractInvocation(SEL selector, id object, const char *file, int line) {
    [NSException raise:NSInvalidArgumentException
                format:@"-%s only defined for abstract class. Define -[%@ %s] in %s:%d!",
                sel_getName(selector), [object class], sel_getName(selector), file, line];
}

static inline void _KGUnimplementedMethod(SEL selector, id object, const char *file, int line) {
    NSLog(@"-[%@ %s] unimplemented in %s at %d", [object class], sel_getName(selector), file, line);
}

static inline void _KGUnimplementedFunction(const char *fname, const char *file, int line) {
    NSLog(@"%s() unimplemented in %s at %d", fname, file, line);
}

#define O2InvalidAbstractInvocation() \
    _KGInvalidAbstractInvocation(_cmd, self, __FILE__, __LINE__)

#define O2UnimplementedMethod() \
    _KGUnimplementedMethod(_cmd, self, __FILE__, __LINE__)

#define O2UnimplementedFunction() \
    _KGUnimplementedFunction(__PRETTY_FUNCTION__, __FILE__, __LINE__)
