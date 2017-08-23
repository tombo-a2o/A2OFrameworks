#import <StoreKit/StoreKit.h>
#import "SKPaymentTransactionStore.h"
#import "SKPaymentTransaction+Internal.h"
#import <sqlite3.h>

#define CREATE_TABLE_STATEMENT "create table if not exists transaction_queue(" \
"requestId TEXT PRIMARY KEY," \
"productIdentifier TEXT NOT NULL," \
"quantity TEXT NOT NULL," \
"requestData TEXT," \
"applicationUsername TEXT," \
"transactionState INTEGER NOT NULL," \
"transactionIdentifier TEXT," \
"transactionDate REAL," \
"transactionReceipt DATA," \
"error DATA" \
");"

#define SELECT_STATEMENT_BY_STATE "select requestId, productIdentifier, quantity, requestData, applicationUsername, transactionState, transactionIdentifier, transactionDate, transactionReceipt, error from transaction_queue where transactionState = ?;"
#define SELECT_STATEMENT_BY_ID "select requestId, productIdentifier, quantity, requestData, applicationUsername, transactionState, transactionIdentifier, transactionDate, transactionReceipt, error from transaction_queue where requestId = ?;"
#define SELECT_STATEMENT_ALL "select requestId, productIdentifier, quantity, requestData, applicationUsername, transactionState, transactionIdentifier, transactionDate, transactionReceipt, error from transaction_queue;"
#define INSERT_STATEMENT "insert into transaction_queue values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
#define UPDATE_STATEMENT "update transaction_queue set transactionState = ?, transactionIdentifier = ?, transactionDate = ?, transactionReceipt = ?, error = ? where requestId = ?;"
#define DELETE_STATEMENT "delete from transaction_queue where requestId = ?;"

#define SQL_ASSERT(cond) do{if(!(cond)) NSLog(@"%s result: %d %s", __FUNCTION__, result, sqlite3_errmsg(_db)); assert(cond);}while(0)

@implementation SKPaymentTransactionStore {
    sqlite3 *_db;
    sqlite3_stmt *_selectStatementByState;
    sqlite3_stmt *_selectStatementById;
    sqlite3_stmt *_selectStatementAll;
    sqlite3_stmt *_insertStatement;
    sqlite3_stmt *_updateStatement;
    sqlite3_stmt *_deleteStatement;
    NSMutableArray<SKPaymentTransaction*>* _transactions;
}

+ (instancetype)defaultStore
{
    return [[SKPaymentTransactionStore alloc] initWithStoragePath:[NSHomeDirectory() stringByAppendingPathComponent:@"transactions.db"]];
}

- (void)createTableIfNotExists
{
    sqlite3_stmt *stmt;
    int result;
    
    result = sqlite3_prepare(_db, CREATE_TABLE_STATEMENT, -1, &stmt, NULL);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_step(stmt);
    SQL_ASSERT(result == SQLITE_DONE);
    result = sqlite3_finalize(stmt);
    SQL_ASSERT(result == SQLITE_OK);
}

- (instancetype)initWithStoragePath:(NSString*)path
{
    SKDebugLog(@"path %@", path);
    
    self = [super init];
    
    int result = sqlite3_open([path UTF8String], &_db);
    if(result != SQLITE_OK) {
        SKDebugLog(@"sqlite returns %d", result);
        return nil;
    }
    
    [self createTableIfNotExists];
    
    result = sqlite3_prepare_v2(_db, SELECT_STATEMENT_BY_STATE, -1, &_selectStatementByState, NULL);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, SELECT_STATEMENT_BY_ID, -1, &_selectStatementById, NULL);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, SELECT_STATEMENT_ALL, -1, &_selectStatementAll, NULL);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, INSERT_STATEMENT, -1, &_insertStatement, NULL);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, UPDATE_STATEMENT, -1, &_updateStatement, NULL);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_prepare_v2(_db, DELETE_STATEMENT, -1, &_deleteStatement, NULL);
    SQL_ASSERT(result == SQLITE_OK);
    
    _transactions = [[NSMutableArray alloc] init];
    [self restoreFromDatabase];
    
    return self;
}

- (void)dealloc
{
    sqlite3_finalize(_selectStatementByState);
    sqlite3_finalize(_selectStatementById);
    sqlite3_finalize(_selectStatementAll);
    sqlite3_finalize(_insertStatement);
    sqlite3_finalize(_updateStatement);
    sqlite3_finalize(_deleteStatement);
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

- (void)insert:(SKPaymentTransaction*)transaction
{
    SKDebugLog(@"%@", transaction);
    [_transactions addObject:transaction];
    
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
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsstring(_insertStatement, 1, requestId);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsstring(_insertStatement, 2, productIdentifier);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_bind_int(_insertStatement, 3, payment.quantity);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsdata_nullable(_insertStatement, 4, requestData);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsstring_nullable(_insertStatement, 5, applicationUsername);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_bind_int(_insertStatement, 6, transaction.transactionState);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsstring_nullable(_insertStatement, 7, transactionIdentifier);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsdate_nullable(_insertStatement, 8, transactionDate);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsdata_nullable(_insertStatement, 9, transactionReceipt);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsdata_nullable(_insertStatement, 10, errorData);
    SQL_ASSERT(result == SQLITE_OK);
    
    result = sqlite3_step(_insertStatement);
    
    if(result != SQLITE_DONE) {
        NSLog(@"%s result: %d %s", __FUNCTION__, result, sqlite3_errmsg(_db));
    }
}

- (void)update:(SKPaymentTransaction*)transaction
{
    SKDebugLog(@"%@", transaction);
    [_transactions replaceObjectAtIndex:[_transactions indexOfObject:transaction] withObject:transaction];

    NSString *requestId = transaction.requestId;
    NSString *transactionIdentifier = transaction.transactionIdentifier;
    NSDate *transactionDate = transaction.transactionDate;
    NSData *transactionReceipt = transaction.transactionReceipt;
    NSData *errorData = [NSKeyedArchiver archivedDataWithRootObject:transaction.error];
    
    int result;
    result = sqlite3_reset(_updateStatement);
    SQL_ASSERT(result == SQLITE_OK);
    result = sqlite3_bind_int(_updateStatement, 1, transaction.transactionState);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsstring_nullable(_updateStatement, 2, transactionIdentifier);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsdate_nullable(_updateStatement, 3, transactionDate);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsdata_nullable(_updateStatement, 4, transactionReceipt);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsdata_nullable(_updateStatement, 5, errorData);
    SQL_ASSERT(result == SQLITE_OK);
    result = bind_nsstring(_updateStatement, 6, requestId);
    SQL_ASSERT(result == SQLITE_OK);
    
    result = sqlite3_step(_updateStatement);
    
    if(result != SQLITE_DONE) {
        NSLog(@"%s result: %d", __FUNCTION__, result);
    }
}

-(void)remove:(SKPaymentTransaction*)transaction
{
    SKDebugLog(@"%@", transaction);
    [_transactions removeObject:transaction];
    
    NSString *requestId = transaction.requestId;
    
    int result;
    result = sqlite3_reset(_deleteStatement);
    result = bind_nsstring(_deleteStatement, 1, requestId);
    SQL_ASSERT(result == SQLITE_OK);
    
    result = sqlite3_step(_deleteStatement);
    
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

static SKPaymentTransaction* parseRow(sqlite3_stmt *stmt)
{
    NSString *requestId = column_nsstring(stmt, 0);
    NSString *productIdentifier = column_nsstring(stmt, 1);
    NSInteger quantity = sqlite3_column_int(stmt, 2);
    NSData *requestData = column_nsdata_nullable(stmt, 3);
    NSString *applicationUsername = column_nsstring_nullable(stmt, 4);
    NSInteger transactionState = sqlite3_column_int(stmt, 5);
    NSString *transactionIdentifier = column_nsstring_nullable(stmt, 6);
    NSDate *transactionDate = column_nsdate_nullable(stmt, 7);
    NSData *transactionReceipt = column_nsdata_nullable(stmt, 8);
    NSData *errorData = column_nsdata_nullable(stmt, 9);
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

- (SKPaymentTransaction*)transactionWithRequestId:(NSString*)requestId
{
    for(SKPaymentTransaction *transaction in _transactions) {
        if([transaction.requestId isEqualToString:requestId]) {
            return transaction;
        }
    }
    return nil;
}

- (SKPaymentTransaction*)incompleteTransaction
{
    return [self incompleteTransactions].firstObject;
}

- (NSArray<SKPaymentTransaction*>*)incompleteTransactions
{
    return [_transactions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"transactionState == 0"]];
}

- (void)restoreFromDatabase
{
    int result;
    result = sqlite3_reset(_selectStatementAll);
    SQL_ASSERT(result == SQLITE_OK);
    
    result = sqlite3_step(_selectStatementAll);
    
    while(result == SQLITE_ROW) {
        SKPaymentTransaction *transaction = parseRow(_selectStatementAll);
        [_transactions addObject:transaction];
        result = sqlite3_step(_selectStatementAll);
    }
}

- (NSArray*)allTransactions
{
    return [_transactions copy];
}

@end
