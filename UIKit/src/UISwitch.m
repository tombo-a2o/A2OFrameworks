/*
 * Copyright (c) 2011, The Iconfactory. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of The Iconfactory nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE ICONFACTORY BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <UIKit/UISwitch.h>
#import <QuartzCore/QuartzCore.h>

#define SWITCH_WIDTH 51
#define SWITCH_HEIGHT 31

@implementation UISwitch {
    CALayer *_knob;
    CALayer *_dimple;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self=[super initWithFrame:frame])) {
        // UIView's initWithFrame: calls setFrame:, so we'll enforce UISwitch's size invariant down there (see below)
        [self _initializeSwitch];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self) {
        _on = [coder decodeBoolForKey:@"UISwitchOn"];
        [self _initializeSwitch];
    }
    return self;
}

- (void)_initializeSwitch
{
    CGColorRef color;
    _knob = [CALayer layer];
    _knob.bounds = CGRectMake(0, 0, SWITCH_HEIGHT-3, SWITCH_HEIGHT-3);
    _knob.borderWidth = 0.5;
    color = CGColorCreateGenericGray(0.5, 0.8);
    _knob.borderColor = color;
    CFRelease(color);
    color = CGColorCreateGenericGray(1.0, 1.0);
    _knob.backgroundColor = color;
    CFRelease(color);
    _knob.cornerRadius = SWITCH_HEIGHT/2-2;
    _knob.zPosition = 1;
    _dimple = [CALayer layer];
    _dimple.borderWidth = 1.5;
    _dimple.frame = CGRectMake(0, 0, SWITCH_WIDTH, SWITCH_HEIGHT);
    _dimple.cornerRadius = SWITCH_HEIGHT/2;
    _dimple.zPosition = 0;
    [self.layer addSublayer:_knob];
    [self.layer addSublayer:_dimple];
    
    [self addTarget:self action:@selector(_toggleSwitch) forControlEvents:UIControlEventTouchUpInside];
    
    [self _updateLayer:NO];
}

- (void)_updateLayer:(BOOL)animated
{
    [CATransaction begin];

    [CATransaction setDisableActions:!animated];
    
    CGColorRef color;
    if(_on) {
        _knob.position = CGPointMake(SWITCH_WIDTH - SWITCH_HEIGHT/2-1, SWITCH_HEIGHT/2+0.5);
        color = CGColorCreateGenericRGB(0.30, 0.85, 0.38, 1.0);
        _dimple.borderColor = color;
        CFRelease(color);
        color = CGColorCreateGenericRGB(0.30, 0.85, 0.38, 1.0);
        _dimple.backgroundColor = color;
        CFRelease(color);
    } else {
        _knob.position = CGPointMake(SWITCH_HEIGHT/2, SWITCH_HEIGHT/2+0.5);
        color = CGColorCreateGenericGray(0.9, 1.0);
        _dimple.borderColor = color;
        CFRelease(color);
        color = CGColorCreateGenericGray(0.0, 0.0);
        _dimple.backgroundColor = color;
        CFRelease(color);
    }
    
    [CATransaction commit];
}

- (void)_toggleSwitch
{
    if(self.on) {
        _on = NO;
    } else {
        _on = YES;
    }
    [self _updateLayer:YES];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    _on = on;
    [self _updateLayer:animated];
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(94, 27);
    [super setFrame:frame];
}

@end
