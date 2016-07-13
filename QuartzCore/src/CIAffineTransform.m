#import <QuartzCore/CIAffineTransform.h>
#import <Foundation/NSKeyedArchiver.h>
#import <Foundation/NSString.h>
#import <Foundation/NSException.h>

@implementation CIAffineTransform

-(void)encodeWithCoder:(NSCoder *)coder {
   [NSException raise:NSGenericException format:@"Unimplemented"];
}

-initWithCoder:(NSCoder *)coder {
   if([coder allowsKeyedCoding]){
    NSKeyedUnarchiver *keyed=(NSKeyedUnarchiver *)coder;

    _transform=[[keyed decodeObjectForKey:@"CI_inputTransform"] copy];
    _ciEnabled=[keyed decodeBoolForKey:@"CIEnabled"];
   }
   return self;
}

-(void)dealloc {
  [_transform release];
  [super dealloc];
}

-(NSAffineTransform *)affineTransform {
   return _transform;
}

@end
