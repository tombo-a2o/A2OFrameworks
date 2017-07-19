#import <Security/SecItem.h>
#import <stdio.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define KEYCHAIN_DB "/keychain.db"

#if defined(KEYCHAIN_DEBUG)
#define DEBUGLOG(...) NSLog(__VA_ARGS__)
#else
#define DEBUGLOG(...)
#endif

NSArray<NSString *>* attributeKeys(void){
    static NSArray<NSString *>* _attributeKeys = nil;
    if(!_attributeKeys) {
        _attributeKeys = [[NSArray alloc] initWithObjects:(__bridge NSString*)kSecAttrService, (__bridge NSString*)kSecAttrAccount, nil];
    }
    return _attributeKeys;
}

bool checkTableExists(sqlite3 *db) {
    sqlite3_stmt *stmt;
    int result;

    result = sqlite3_prepare(db, "select count(*) from sqlite_master where type='table' and name='keychain';", -1, &stmt, NULL);
    assert(result == SQLITE_OK);
    result = sqlite3_step(stmt);
    assert(result == SQLITE_ROW);
    int count = sqlite3_column_int(stmt, 0);
    result = sqlite3_finalize(stmt);
    assert(result == SQLITE_OK);

    return count == 1;
}

void createTableIfNotExists(sqlite3 *db) {
    if(checkTableExists(db)) return;

    sqlite3_stmt *stmt;
    int result;

    NSMutableString *statement = [NSMutableString stringWithString:@"create table keychain("];
    for(NSString *key in attributeKeys()) {
        [statement appendString:key];
        [statement appendString:@" TEXT, "];
    }
    [statement appendString:@"data BLOB);"];

    result = sqlite3_prepare(db, [statement UTF8String], -1, &stmt, NULL);
    assert(result == SQLITE_OK);
    result = sqlite3_step(stmt);
    assert(result == SQLITE_DONE);
    result = sqlite3_finalize(stmt);
    assert(result == SQLITE_OK);
}

static inline NSString *convertToString(id obj) {
    if([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if([obj isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData*)obj encoding:NSUTF8StringEncoding];
    } else if(!obj){
        return nil;
    } else {
        assert(0);
    }
}

static inline NSString *whereClause(NSDictionary* query) {
    NSMutableArray *conditions = [NSMutableArray array];

    for(NSString *key in attributeKeys()) {
        NSString *value = convertToString([query objectForKey:key]);
        if(value) {
            [conditions addObject:[NSString stringWithFormat:@"%@ = :%@", key, key]];
        }
    }

    if(conditions.count > 0) {
        return [@" where " stringByAppendingString:[conditions componentsJoinedByString:@" and "]];
    } else {
        return @"";
    }
}

static inline NSString *selectStatement(NSDictionary* query) {
    return [@"select data from keychain" stringByAppendingString:whereClause(query)];
}

static inline NSString *insertStatement(NSDictionary *_query) {
    NSMutableArray *keys = [NSMutableArray array];
    for(NSString *key in attributeKeys()) {
        [keys addObject:[@":" stringByAppendingString:key]];
    }
    [keys addObject:@":data"];

    return [NSString stringWithFormat:@"insert into keychain values(%@)", [keys componentsJoinedByString:@", "]];
}

static inline NSString *updateStatement(NSDictionary* query) {
    return [@"update set data = :data " stringByAppendingString:whereClause(query)];
}

static inline NSString *deleteStatement(NSDictionary* query) {
    return [@"delete from keychain" stringByAppendingString:whereClause(query)];
}

static inline void bindParameter(sqlite3_stmt *stmt, NSDictionary* query) {
    for(NSString* key in attributeKeys()) {
        NSString *value = convertToString([query objectForKey:key]);
        if(value) {
            int idx = sqlite3_bind_parameter_index(stmt, [[@":" stringByAppendingString:key] UTF8String]);
            assert(idx != 0);

            int result = sqlite3_bind_text(stmt, idx, [value UTF8String], value.length, NULL);
            assert(result == SQLITE_OK);
        }
    }
}

static inline void bindParameterWithData(sqlite3_stmt *stmt, NSDictionary* query) {
    bindParameter(stmt, query);

    NSData *data = [query objectForKey:(__bridge id)kSecValueData];
    int idx = sqlite3_bind_parameter_index(stmt, ":data");
    assert(idx != 0);
    int result = sqlite3_bind_blob(stmt, idx, [data bytes], data.length, NULL);
    assert(result == SQLITE_OK);
}

OSStatus SecItemCopyMatching(CFDictionaryRef _query, CFTypeRef *_result)
{
    NSDictionary *query = (__bridge NSDictionary *)_query;

    DEBUGLOG(@"%s: %@", __FUNCTION__, query);

    NSObject *secClass = [query objectForKey:(__bridge id)kSecClass];
    if(secClass != kSecClassGenericPassword) {
        NSLog(@"%s: only kSecClassGenericPassword is supported", __FUNCTION__);
        return errSecUnimplemented;
    }

    NSNumber *returnData = [query objectForKey:(__bridge id)kSecReturnData];
    NSNumber *returnAttributes = [query objectForKey:(__bridge id)kSecReturnAttributes];
    NSNumber *returnRef = [query objectForKey:(__bridge id)kSecReturnRef];
    NSNumber *returnPersistentRef = [query objectForKey:(__bridge id)kSecReturnPersistentRef];

    if(returnAttributes && [returnAttributes boolValue]) {
        NSLog(@"%s: kSecReturnAttributes=true is not supported", __FUNCTION__);
        return errSecUnimplemented;
    }
    if(returnRef && [returnRef boolValue]) {
        NSLog(@"%s: kSecReturnRef=true is not supported", __FUNCTION__);
        return errSecUnimplemented;
    }
    if(returnPersistentRef && [returnPersistentRef boolValue]) {
        NSLog(@"%s: returnPersistentRef=true is not supported", __FUNCTION__);
        return errSecUnimplemented;
    }

    NSString *matchLimit = [query objectForKey:(__bridge id)kSecMatchLimit];

    if(matchLimit && matchLimit != kSecMatchLimitOne) {
        NSLog(@"%s: only kSecMatchLimitOne=true is supported", __FUNCTION__);
        return errSecUnimplemented;
    }

    // assert(![returnData boolValue]);
    sqlite3 *db;
    sqlite3_stmt *stmt;
    int result;
    OSStatus status;

    result = sqlite3_open(KEYCHAIN_DB, &db);
    if(result != SQLITE_OK) {
        NSLog(@"%s: sqlite returns %d", __FUNCTION__, result);
        return errSecIO;
    }
    createTableIfNotExists(db);

    DEBUGLOG(@"%@", selectStatement(query));
    result = sqlite3_prepare_v2(db, [selectStatement(query) UTF8String], -1, &stmt, NULL);
    assert(result == SQLITE_OK);
    bindParameter(stmt, query);

    result = sqlite3_step(stmt);
    if(result == SQLITE_ROW) {
        const void* data = sqlite3_column_blob(stmt, 0);
        int length = sqlite3_column_bytes(stmt, 0);
        if(_result && returnData.boolValue) {
            *_result = (__bridge_retained CFTypeRef)[NSData dataWithBytes:data length:length];
        }
        status = errSecSuccess;
    } else {
        status = errSecItemNotFound;
    }

    result = sqlite3_finalize(stmt);
    assert(result == SQLITE_OK);

    sqlite3_close(db);

    return status;
}



OSStatus SecItemAdd(CFDictionaryRef _attributes, CFTypeRef *_result)
{
    NSDictionary *attributes = (__bridge NSDictionary *)_attributes;

    DEBUGLOG(@"%s attributes: %@", __FUNCTION__, attributes);

    NSObject *secClass = [attributes objectForKey:(__bridge id)kSecClass];
    if(secClass != kSecClassGenericPassword) {
        NSLog(@"%s: only kSecClassGenericPassword is supported", __FUNCTION__);
        return errSecUnimplemented;
    }

    sqlite3 *db;
    sqlite3_stmt *stmt;
    int result;
    OSStatus status;

    result = sqlite3_open(KEYCHAIN_DB, &db);
    if(result != SQLITE_OK) {
        NSLog(@"%s: sqlite returns %d", __FUNCTION__, result);
        return errSecIO;
    }
    createTableIfNotExists(db);

    DEBUGLOG(@"%@", insertStatement(attributes));
    result = sqlite3_prepare_v2(db, [insertStatement(attributes) UTF8String], -1, &stmt, NULL);
    assert(result == SQLITE_OK);
    bindParameterWithData(stmt, attributes);

    result = sqlite3_step(stmt);
    if(result == SQLITE_DONE) {
        status = errSecSuccess;
    } else {
        status = errSecItemNotFound;
    }
    result = sqlite3_finalize(stmt);
    assert(result == SQLITE_OK);

    sqlite3_close(db);

    return status;
}


OSStatus SecItemUpdate(CFDictionaryRef _attributes, CFDictionaryRef attributesToUpdate)
{
    NSDictionary *attributes = (__bridge NSDictionary *)_attributes;

    NSObject *secClass = [attributes objectForKey:(__bridge id)kSecClass];
    if(secClass != kSecClassGenericPassword) {
        NSLog(@"%s: only kSecClassGenericPassword is supported", __FUNCTION__);
        return errSecUnimplemented;
    }

    sqlite3 *db;
    sqlite3_stmt *stmt;
    int result;
    OSStatus status;

    result = sqlite3_open(KEYCHAIN_DB, &db);
    if(result != SQLITE_OK) {
        NSLog(@"%s: sqlite returns %d", __FUNCTION__, result);
        return errSecIO;
    }
    createTableIfNotExists(db);

    DEBUGLOG(@"%@", updateStatement(attributes));
    result = sqlite3_prepare_v2(db, [updateStatement(attributes) UTF8String], -1, &stmt, NULL);
    assert(result == SQLITE_OK);
    bindParameterWithData(stmt, attributes);

    result = sqlite3_step(stmt);
    if(result == SQLITE_DONE) {
        status = errSecSuccess;
    } else {
        status = errSecItemNotFound;
    }
    result = sqlite3_finalize(stmt);
    assert(result == SQLITE_OK);

    sqlite3_close(db);

    return status;
}

OSStatus SecItemDelete(CFDictionaryRef _query)
{
    NSDictionary *query = (__bridge NSDictionary *)_query;

    DEBUGLOG(@"%s: %@", __FUNCTION__, query);

    NSObject *secClass = [query objectForKey:(__bridge id)kSecClass];
    if(secClass != kSecClassGenericPassword) {
        NSLog(@"%s: only kSecClassGenericPassword is supported", __FUNCTION__);
        return errSecUnimplemented;
    }

    sqlite3 *db;
    sqlite3_stmt *stmt;
    int result;
    OSStatus status;

    result = sqlite3_open(KEYCHAIN_DB, &db);
    if(result != SQLITE_OK) {
        NSLog(@"%s: sqlite returns %d", __FUNCTION__, result);
        return errSecIO;
    }
    createTableIfNotExists(db);

    DEBUGLOG(@"%@", deleteStatement(query));
    result = sqlite3_prepare_v2(db, [deleteStatement(query) UTF8String], -1, &stmt, NULL);
    bindParameter(stmt, query);

    result = sqlite3_step(stmt);
    if(result == SQLITE_DONE) {
        status = errSecSuccess;
    } else {
        status = errSecItemNotFound;
    }

    result = sqlite3_finalize(stmt);
    assert(result == SQLITE_OK);

    sqlite3_close(db);

    return status;
}
