/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <Foundation/Foundation.h>
#import <AppKit/AppKitExport.h>

APPKIT_EXPORT NSString *const NSFontAttributeName;
APPKIT_EXPORT NSString *const NSParagraphStyleAttributeName;
APPKIT_EXPORT NSString *const NSForegroundColorAttributeName;
APPKIT_EXPORT NSString *const NSBackgroundColorAttributeName;
APPKIT_EXPORT NSString *const NSUnderlineStyleAttributeName;
APPKIT_EXPORT NSString *const NSUnderlineColorAttributeName;
APPKIT_EXPORT NSString *const NSAttachmentAttributeName;
APPKIT_EXPORT NSString *const NSKernAttributeName;
APPKIT_EXPORT NSString *const NSLigatureAttributeName;
APPKIT_EXPORT NSString *const NSStrikethroughStyleAttributeName;
APPKIT_EXPORT NSString *const NSStrikethroughColorAttributeName;
APPKIT_EXPORT NSString *const NSObliquenessAttributeName;
APPKIT_EXPORT NSString *const NSStrokeWidthAttributeName;
APPKIT_EXPORT NSString *const NSStrokeColorAttributeName;
APPKIT_EXPORT NSString *const NSBaselineOffsetAttributeName;
APPKIT_EXPORT NSString *const NSSuperscriptAttributeName;
APPKIT_EXPORT NSString *const NSLinkAttributeName;
APPKIT_EXPORT NSString *const NSShadowAttributeName;
APPKIT_EXPORT NSString *const NSExpansionAttributeName;
APPKIT_EXPORT NSString *const NSCursorAttributeName;
APPKIT_EXPORT NSString *const NSToolTipAttributeName;
APPKIT_EXPORT NSString *const NSBackgroundColorDocumentAttribute;

APPKIT_EXPORT NSString *const NSSpellingStateAttributeName;

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
