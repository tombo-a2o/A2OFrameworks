/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <Foundation/Foundation.h>

extern NSString *const NSFontAttributeName;
extern NSString *const NSParagraphStyleAttributeName;
extern NSString *const NSForegroundColorAttributeName;
extern NSString *const NSBackgroundColorAttributeName;
extern NSString *const NSUnderlineStyleAttributeName;
extern NSString *const NSUnderlineColorAttributeName;
extern NSString *const NSAttachmentAttributeName;
extern NSString *const NSKernAttributeName;
extern NSString *const NSLigatureAttributeName;
extern NSString *const NSStrikethroughStyleAttributeName;
extern NSString *const NSStrikethroughColorAttributeName;
extern NSString *const NSObliquenessAttributeName;
extern NSString *const NSStrokeWidthAttributeName;
extern NSString *const NSStrokeColorAttributeName;
extern NSString *const NSBaselineOffsetAttributeName;
extern NSString *const NSSuperscriptAttributeName;
extern NSString *const NSLinkAttributeName;
extern NSString *const NSShadowAttributeName;
extern NSString *const NSExpansionAttributeName;
extern NSString *const NSCursorAttributeName;
extern NSString *const NSToolTipAttributeName;
extern NSString *const NSBackgroundColorDocumentAttribute;

extern NSString *const NSSpellingStateAttributeName;

enum {
    NSSpellingStateSpellingFlag = 0x01,
    NSSpellingStateGrammarFlag = 0x02,
};

enum {
    NSUnderlineStyleNone,
    NSUnderlineStyleSingle,
    NSUnderlineStyleThick,
    NSUnderlineStyleDouble,
};

// Deprecated constants
enum {
    NSNoUnderlineStyle = NSUnderlineStyleNone,
    NSSingleUnderlineStyle = NSUnderlineStyleSingle,
};

enum {
    NSUnderlinePatternSolid = 0x000,
    NSUnderlinePatternDot = 0x100,
    NSUnderlinePatternDash = 0x200,
    NSUnderlinePatternDashDot = 0x300,
    NSUnderlinePatternDashDotDot = 0x400,
};
