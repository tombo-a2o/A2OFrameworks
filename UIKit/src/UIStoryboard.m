//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSBundle.h>
#import <AppKit/NSNib.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIStoryboard.h>

@implementation UIStoryboard {
    NSString *_entryPoint;
    NSDictionary *_fileMap;
    NSString *_path;
    NSBundle *_bundle;
}

+(instancetype) storyboardWithName:(NSString*)name bundle:(NSBundle*)bundle {
    return [[UIStoryboard alloc] initWithName:name bundle:bundle];
}

-(instancetype)initWithName:(NSString*)name bundle:(NSBundle*)bundle {
    _path = [name stringByAppendingString:@".storyboardc"];

    _bundle = bundle ?: [NSBundle mainBundle];

    NSString *storyInfoPath = [_bundle pathForResource:@"Info" ofType:@"plist" inDirectory:_path];

    if (!storyInfoPath) {
        return nil;
    }
    NSDictionary *storyInfo = [NSDictionary dictionaryWithContentsOfFile:storyInfoPath];
    if (storyInfo) {
        _entryPoint = [storyInfo objectForKey:@"UIStoryboardDesignatedEntryPointIdentifier"];
        _fileMap = [storyInfo objectForKey:@"UIViewControllerIdentifiersToNibNames"];
    }
    DEBUGLOG(@"%@ %@ %@ %@ %@", _path, storyInfoPath, storyInfo, _entryPoint, _fileMap);

    return self;
}

-(UIViewController*) instantiateInitialViewController {
    return [self instantiateViewControllerWithIdentifier:_entryPoint];
}

-(UIViewController*) instantiateViewControllerWithIdentifier:(NSString*)identifier {
    NSString *fileName = [_fileMap objectForKey:identifier];
    NSString *runtimePath = [[_path stringByAppendingPathComponent:fileName] stringByAppendingString:@".nib"];
    NSString *pathToNib = [_bundle pathForResource:@"runtime" ofType:@"nib" inDirectory:runtimePath];
    if ( pathToNib == nil ) {
        pathToNib = [[NSBundle mainBundle] pathForResource:fileName ofType:@"nib" inDirectory:_path];
    }

    NSNib *nib = [[NSNib alloc] init];

    UIApplication *uiApplication = [UIApplication sharedApplication];
    //NSDictionary *proxies = [NSDiction dictionaryWithObjectsAndKeys:uiApplication,@"UpstreamPlaceholder-1",self,@"UIStoryboardPlaceholder",nil];
    NSDictionary *proxies = @{ @"UpstreamPlaceholder-1": uiApplication, @"UIStoryboardPlaceholder": self};

    NSArray *objs = [nib loadNib:pathToNib withOwner:uiApplication proxies:proxies];
    if(objs) {
        int count = [objs count];

        for ( int i = 0; i < count; i ++ ) {
            id curObj = [objs objectAtIndex:i];

            if ( [curObj isKindOfClass:[UIViewController class]] ) {
                return curObj;
            }
        }
    }

    return nil;
}

-(NSString*) _path {
    return _path;
}

@end
