#import <StoreKit/StoreKit.h>
#import "SKPaymentTransactionStore.h"
#import "SKPaymentTransaction+Internal.h"
#import <sqlite3.h>

#define CREATE_TABLE_STATEMENT "create table if not exists transaction_queue(" \
    "requestId TEXT PRIMARY KEY," \
    "productIdentifier TEXT," \
    "quantity TEXT," \
    "requestData TEXT," \
    "applicationUsername TEXT," \
    "transactionState INTEGER," \
    "transactionIdentifier TEXT," \
    "transactionDate REAL," \
    "transactionReceipt DATA," \
    "error DATA" \
    ");"

#define SELECT_STATEMENT_BY_STATE "select requestId, productIdentifier, quantity, requestData, applicationUsername, transactionState, transactionIdentifier, transactionDate, transactionReceipt, error from transaction_queue where transactionState = ?;"
#define SELECT_STATEMENT_BY_ID "select requestId, productIdentifier, quantity, requestData, applicationUsername, transactionState, transactionIdentifier, transactionDate, transactionReceipt, error from transaction_queue where requestId = ?;"
#define INSERT_STATEMENT "insert into transaction_queue values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
#define UPDATE_STATEMENT "update transaction_queue set transactionState = ?, transactionIdentifier = ?, transactionDate = ?, transactionReceipt = ?, error = ? where requestId = ?;"

@implementation SKPaymentTransactionStore {
    sqlite3 *_db;
    sqlite3_stmt *_selectStatementByState;
    sqlite3_stmt *_selectStatementById;
    sqlite3_stmt *_insertStatement;
    sqlite3_stmt *_updateStatement;
}

+ (instancetype)defaultStore
{
    return [[SKPaymentTransactionStore alloc] init];
}

- (NSString*)queueStorage
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"transactions.db"];
}

static void createTableIfNotExists(sqlite3 *db) {
    sqlite3_stmt *stmt;
    int result;

    result = sqlite3_prepare(db, CREATE_TABLE_STATEMENT, -1, &stmt, NULL);
    assert(result == SQLITE_OK);
    result = sqlite3_step(stmt);
    assert(result == SQLITE_DONE);
    result = sqlite3_finalize(stmt);
    assert(result == SQLITE_OK);
}

-(instancetype)init
{
    self = [super init];

    int result = sqlite3_open([[self queueStorage] UTF8String], &_db);
    if(result != SQLITE_OK) {
        SKDebugLog(@"sqlite returns %d", result);
        return nil;
    }

    createTableIfNotExists(_db);

    result = sqlite3_prepare_v2(_db, SELECT_STATEMENT_BY_STATE, -1, &_selectStatementByState, NULL);
    assert(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, SELECT_STATEMENT_BY_ID, -1, &_selectStatementById, NULL);
    assert(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, INSERT_STATEMENT, -1, &_insertStatement, NULL);
    assert(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, UPDATE_STATEMENT, -1, &_updateStatement, NULL);
    assert(result == SQLITE_OK);

    return self;
}

- (void)dealloc
{
    sqlite3_finalize(_selectStatementByState);
    sqlite3_finalize(_selectStatementById);
    sqlite3_finalize(_updateStatement);
    sqlite3_close(_db);
}

static int bind_nsstring(sqlite3_stmt *stmt, int idx, NSString *str)
{
    return sqlite3_bind_text(stmt, idx, str.UTF8String, str.length, NULL);
}

static int bind_nsstring_nullable(sqlite3_stmt *stmt, int idx, NSString *str)
{
    return str ? bind_nsstring(stmt, idx, str) : sqlite3_bind_null(stmt, idx);
}

static int bind_nsdata(sqlite3_stmt *stmt, int idx, NSData *data)
{
    return sqlite3_bind_blob(stmt, idx, data.bytes, data.length, NULL);
}

static int bind_nsdata_nullable(sqlite3_stmt *stmt, int idx, NSData *data)
{
    return data ? bind_nsdata(stmt, idx, data) : sqlite3_bind_null(stmt, idx);
}

static int bind_nsdate(sqlite3_stmt *stmt, int idx, NSDate *date)
{
    return sqlite3_bind_double(stmt, idx, date.timeIntervalSinceReferenceDate);
}

static int bind_nsdate_nullable(sqlite3_stmt *stmt, int idx, NSDate *date)
{
    return date ? bind_nsdate(stmt, idx, date) : sqlite3_bind_null(stmt, idx);
}

-(void)push:(SKPaymentTransaction*)transaction
{
    SKPayment *payment = transaction.payment;

    NSString *requestId = transaction.requestId;
    NSString *productIdentifier = payment.productIdentifier;
    NSData *requestData = payment.requestData;
    NSString *applicationUsername = payment.applicationUsername;
    NSString *transactionIdentifier = transaction.transactionIdentifier;
    NSDate *transactionDate = transaction.transactionDate;
    NSData *transactionReceipt = transaction.transactionReceipt;
    NSData *errorData = transaction.error ? [NSKeyedArchiver archivedDataWithRootObject:transaction.error] : nil;

    int result;
    result = sqlite3_reset(_insertStatement);
    result = bind_nsstring(_insertStatement, 1, requestId);
    result = bind_nsstring(_insertStatement, 2, productIdentifier);
    result = sqlite3_bind_int(_insertStatement, 3, payment.quantity);
    result = bind_nsdata_nullable(_insertStatement, 4, requestData);
    result = bind_nsstring_nullable(_insertStatement, 5, applicationUsername);
    result = sqlite3_bind_int(_insertStatement, 6, transaction.transactionState);
    result = bind_nsstring_nullable(_insertStatement, 7, transactionIdentifier);
    result = bind_nsdate_nullable(_insertStatement, 8, transactionDate);
    result = bind_nsdata_nullable(_insertStatement, 9, transactionReceipt);
    result = bind_nsdata_nullable(_insertStatement, 10, errorData);

    result = sqlite3_step(_insertStatement);

    if(result != SQLITE_DONE) {
        NSLog(@"%s result: %d", __FUNCTION__, result);
    }
}

-(void)update:(SKPaymentTransaction*)transaction
{
    NSString *requestId = transaction.requestId;
    NSString *transactionIdentifier = transaction.transactionIdentifier;
    NSDate *transactionDate = transaction.transactionDate;
    NSData *transactionReceipt = transaction.transactionReceipt;
    NSData *errorData = [NSKeyedArchiver archivedDataWithRootObject:transaction.error];

    int result;
    result = sqlite3_reset(_updateStatement);
    result = sqlite3_bind_int(_updateStatement, 1, transaction.transactionState);
    result = transactionIdentifier ? sqlite3_bind_text(_insertStatement, 2, transactionIdentifier.UTF8String, transactionIdentifier.length, NULL) : sqlite3_bind_null(_insertStatement, 2);
    result = transactionDate ? sqlite3_bind_double(_insertStatement, 3, transactionDate.timeIntervalSinceReferenceDate) : sqlite3_bind_null(_insertStatement, 3);
    result = transactionReceipt ? sqlite3_bind_blob(_insertStatement, 4, transactionReceipt.bytes, transactionReceipt.length, NULL) : sqlite3_bind_null(_insertStatement, 4);
    result = errorData ? sqlite3_bind_blob(_insertStatement, 5, errorData.bytes, errorData.length, NULL) : sqlite3_bind_null(_insertStatement, 5);
    result = sqlite3_bind_text(_updateStatement, 6, requestId.UTF8String, requestId.length, NULL);

    result = sqlite3_step(_updateStatement);

    if(result != SQLITE_DONE) {
        NSLog(@"%s result: %d", __FUNCTION__, result);
    }
}

static BOOL column_is_null(sqlite3_stmt* stmt, int col)
{
    return sqlite3_column_type(stmt, col) == SQLITE_NULL;
}

static NSString* column_nsstring(sqlite3_stmt* stmt, int col)
{
    return [NSString stringWithUTF8String:sqlite3_column_text(stmt, col)];
}

static NSString* column_nsstring_nullable(sqlite3_stmt* stmt, int col)
{
    return column_is_null(stmt, col) ? nil : column_nsstring(stmt, col);
}

static NSData* column_nsdata(sqlite3_stmt* stmt, int col)
{
    return [NSData dataWithBytes:sqlite3_column_blob(stmt, col) length:sqlite3_column_bytes(stmt, col)];
}

static NSData* column_nsdata_nullable(sqlite3_stmt* stmt, int col)
{
    return column_is_null(stmt, col) ? nil : column_nsdata(stmt, col);
}

static NSDate* column_nsdate(sqlite3_stmt* stmt, int col)
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:sqlite3_column_double(stmt, col)];
}

static NSDate* column_nsdate_nullable(sqlite3_stmt* stmt, int col)
{
    return column_is_null(stmt, col) ? nil : column_nsdate(stmt, col);
}

-(SKPaymentTransaction*)popIncomplete
{
    int result;
    result = sqlite3_reset(_selectStatementByState);
    result = sqlite3_bind_int(_selectStatementByState, 1, SKPaymentTransactionStatePurchasing);

    result = sqlite3_step(_selectStatementByState);
    if(result != SQLITE_ROW) {
        return nil;
    }

    NSString *requestId = column_nsstring(_selectStatementByState, 1);
    NSString *productIdentifier = column_nsstring(_selectStatementByState, 2);
    NSInteger quantity = sqlite3_column_int(_selectStatementByState, 3);
    NSData *requestData = column_nsdata_nullable(_selectStatementByState, 4);
    NSString *applicationUsername = column_nsstring_nullable(_selectStatementByState, 5);
    NSInteger transactionState = sqlite3_column_int(_selectStatementByState, 6);
    NSString *transactionIdentifier = column_nsstring_nullable(_selectStatementByState, 7);
    NSDate *transactionDate = column_nsdate_nullable(_selectStatementByState, 8);
    NSData *transactionReceipt = column_nsdata_nullable(_selectStatementByState, 9);
    NSData *errorData = column_nsdata_nullable(_selectStatementByState, 10);
    NSError *error = errorData ? [NSKeyedUnarchiver unarchiveObjectWithData:errorData] : nil;

    SKMutablePayment *payment = [[SKPayment paymentWithProductIdentifier:productIdentifier] mutableCopy];
    payment.quantity = quantity;
    payment.requestData = requestData;
    payment.applicationUsername = applicationUsername;
    SKPaymentTransaction *transaction = [[SKPaymentTransaction alloc] initWithPayment:payment];
    transaction.requestId = requestId;
    transaction.transactionState = transactionState;
    transaction.transactionIdentifier = transactionIdentifier;
    transaction.transactionDate = transactionDate;
    transaction.transactionReceipt = transactionReceipt;
    transaction.error = error;

    return transaction;
}

@end
