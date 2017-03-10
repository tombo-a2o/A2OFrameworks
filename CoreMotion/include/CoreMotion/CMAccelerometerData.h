#import <Foundation/Foundation.h>
#import <CoreMotion/CMLogItem.h>

typedef struct CMAcceleration {
    double x;
    double y;
    double z;
} CMAcceleration;

@interface CMAccelerometerData : CMLogItem
@property(readonly, nonatomic) CMAcceleration acceleration;
@end
