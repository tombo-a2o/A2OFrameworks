//
//  NSSpellEngine_hunspellDictionary.m
//  NSSpellEngine_hunspell
//
//  Created by Christopher Lloyd on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSSpellEngine_hunspellDictionary.h"
#import <Foundation/NSTextCheckingResult.h>
#import <Foundation/NSPathUtilities.h>
#import <string.h>
#import <Foundation/NSString.h>

/* hunspelldll.h is a rough C cover over the C++ library, if more functionality is needed use the C++
   library directly.
 */

// hunspell includes use 'near' identifier for method name, but windows.h #defines near
// However, windows.h should not be included in public Foundation headers, so that needs to be
// cleaned up. For now we #undef near

#undef near
#import "hunspelldll.h"

@implementation NSSpellEngine_hunspellDictionary

- initWithContentsOfFile:(NSString *)path {
    _path = [path copy];
    NSString *affPath = _path;
    NSString *dicPath = [[_path stringByDeletingPathExtension] stringByAppendingPathExtension:@"dic"];

    _hunspell = hunspell_initialize((char *)[affPath fileSystemRepresentation], (char *)[dicPath fileSystemRepresentation]);
    return self;
}

- (NSString *)localeIdentifier {
    return [[_path lastPathComponent] stringByDeletingPathExtension];
}

- (NSString *)language {
    return [self localeIdentifier];
}

- (char *)createHunspellStringForString:(NSString *)string {
    if(string == nil) {
        return NULL;
    }
    NSStringEncoding stringEncoding = (NSStringEncoding)0;
    char *encoding = hunspell_get_dic_encoding((Hunspell *)_hunspell);

    if(strcmp(encoding, "ISO8859-1") == 0 || strcmp(encoding, "ISO8859-15") == 0) {
        stringEncoding = NSISOLatin1StringEncoding;
    } else if(encoding == NULL || strcmp(encoding, "UTF-8") == 0) {
        stringEncoding = NSUTF8StringEncoding;
    }

    if(stringEncoding == 0) {
        NSLog(@"Unhandled hunspell dictionary encoding %s", encoding);
        return NULL;
    }
    char *result = NULL;
    const char *cstr = [string cStringUsingEncoding:stringEncoding];
    if(cstr) {
        result = strdup(cstr);
    }
    return result;
}

- (char *)createHunspellStringForCharacters:(unichar *)characters length:(NSUInteger)length {
    NSString *string = [NSString stringWithCharacters:characters length:length];
    return [self createHunspellStringForString:string];
}

- (NSArray *)textCheckingResultWithRange:(NSRange)range forCharacters:(unichar *)characters length:(NSUInteger)length {
    char *string = [self createHunspellStringForCharacters:characters length:length];

    if(string == NULL) {
        /* Word contains a character outside of IS8859-1, I guess this is a spelling error. */
        NSTextCheckingResult *result = [NSTextCheckingResult spellCheckingResultWithRange:range];

        return [NSArray arrayWithObject:result];
    } else {
        if(hunspell_spell((Hunspell *)_hunspell, string) == 0) {
            NSTextCheckingResult *result = [NSTextCheckingResult spellCheckingResultWithRange:range];

            return [NSArray arrayWithObject:result];
        }
    }

    return nil;
}

- (NSArray *)suggestGuessesForWord:(NSString *)word {
    NSMutableArray *result = [NSMutableArray array];

    char **slst;
    char *string = [self createHunspellStringForString:word];

    if(string == NULL)
        return nil;

    int i, len = hunspell_suggest((Hunspell *)_hunspell, string, &slst);

    free(string);

    for(i = 0; i < len && slst != NULL; i++) {
        NSString *guess = [[[NSString alloc] initWithBytes:slst[i] length:strlen(slst[i]) encoding:NSUTF8StringEncoding] autorelease];
        [result addObject:guess];
    }

    hunspell_suggest_free((Hunspell *)_hunspell, slst, len);

    return result;
}

@end
