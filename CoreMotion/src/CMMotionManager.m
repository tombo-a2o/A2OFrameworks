#import <CoreMotion/CoreMotion.h>

@implementation CMMotionManager
- (void)startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAccelerometerHandler)handler
{
  NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)startAccelerometerUpdates;
{
  NSLog(@"*** %s is not implemented", __FUNCTION__);
}

- (void)stopAccelerometerUpdates;
{
  NSLog(@"*** %s is not implemented", __FUNCTION__);
}

@end
