#ifdef DEBUG
#define SKDebugLog(fmt,...) NSLog((@"%s %d "fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define SKDebugLog(...)
#endif

#import <StoreKit/SKBase.h>
#import <StoreKit/SKDownload.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKProductsResponse.h>
#import <StoreKit/SKRequest.h>
#import <StoreKit/SKStoreProductViewController.h>