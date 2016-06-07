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

#import <Foundation/Foundation.h>

@interface NSNib : NSObject
- (instancetype)initWithNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle;
- (instancetype)initWithNibData:(NSData *)nibData bundle:(NSBundle *)bundle;
- (NSArray*)loadNib:(NSString*)filename withOwner:(id)ownerObject;
- (NSArray*)loadNib:(NSString*)filename withOwner:(id)ownerObject proxies:(NSDictionary*)proxies;
@end
