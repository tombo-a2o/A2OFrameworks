#import <Foundation/Foundation.h>

@class ACAccountType, ACAccountCredential;

@interface ACAccount : NSObject
@property(copy, nonatomic) NSString *accountDescription;
@property(strong, nonatomic) ACAccountType *accountType;
@property(strong, nonatomic) ACAccountCredential *credential;
@property(readonly, weak, nonatomic) NSString *identifier;
@property(copy, nonatomic) NSString *username;
@end
