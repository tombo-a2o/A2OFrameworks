#import <Foundation/Foundation.h>

@class CMAccelerometerData;

typedef void (^CMAccelerometerHandler)(CMAccelerometerData *accelerometerData, NSError *error);

@interface CMMotionManager : NSObject
@property(assign, nonatomic) NSTimeInterval accelerometerUpdateInterval;
- (void)startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue 
                             withHandler:(CMAccelerometerHandler)handler;
- (void)startAccelerometerUpdates;
- (void)stopAccelerometerUpdates;
@end
