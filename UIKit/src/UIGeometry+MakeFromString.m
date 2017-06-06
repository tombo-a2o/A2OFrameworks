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
#import <UIKit/UIGeometry.h>
#import <Foundation/NSString.h>

CGPoint CGPointFromString(NSString *strPt) {
    CGPoint ret;

    char* str = (char*)[strPt UTF8String];
    sscanf(str, "{%f, %f}", &ret.x, &ret.y);
    return ret;
}

CGSize CGSizeFromString(NSString *strSize) {
    CGSize ret;

    char* str = (char*)[strSize UTF8String];
    sscanf(str, "{%f, %f}", &ret.width, &ret.height);
    return ret;
}

CGRect CGRectFromString(NSString *strRect) {
    CGRect ret;

    char* str = (char*)[strRect UTF8String];
    sscanf(str, "{{%f, %f}, {%f, %f}}", &ret.origin.x, &ret.origin.y, &ret.size.width, &ret.size.height);
    return ret;
}
