//
//  AppDBAdapter.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 30..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "AppDBAdapter.h"
#import <sqlite3.h>
#import "AppSession.h"

@implementation AppDBAdapter

+ (void)initDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"[AppDBAdapter/initDB] cafejakco.sqlite3 DB 존재");
        return;
    }
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        // 에러 날 경우 에러메시지, 어플리케이션 종료 로직 추가해야함
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/initDB] Sqlite Open Error");
        return;
    }
    
    char *sql = "CREATE TABLE cafejakco_meta (no INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, key CHAR, value CHAR);"\
    //"CREATE INDEX IND_itemNm_ctrdNm ON heritageTable(itemNm, ctrdNm)";
    "CREATE INDEX IND_key ON cafejakco_meta(key)";
    
    if (sqlite3_exec(database, sql, nil, nil, nil) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/initDB] cafejakco_meta Table 생성 error");
        return;
    }
    NSLog(@"[AppDBAdapter/initDB] cafejakco_meta Table 생성");
    
    /* Init */
    [self AddContentsWithKey:@"userid" value:@""];
    [self AddContentsWithKey:@"username" value:@""];
    [self AddContentsWithKey:@"nickname" value:@""];
    [self AddContentsWithKey:@"islogin" value:@"NO"];
    sqlite3_close(database);
}

+ (void)AddContentsWithKey:(NSString *)key value:(NSString *)value
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"[AppDBAdapter/initDB] cafejakco.sqlite3 DB 존재하지 않음");
        return;
    }
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        // 에러 날 경우 에러메시지, 어플리케이션 종료 로직 추가해야함
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/AddContentsWithKey] Sqlite Open Error");
        return;
    }
    
    sqlite3_stmt *statement;
    char *sql = "INSERT INTO cafejakco_meta (key, value) VALUES(?, ?)";
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"[AppDBAdapter/AddContentsWithKey] Sqlite3 Step Error");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}

+ (void)UpdateContentsWithKey:(NSString *)key value:(NSString *)value
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"[AppDBAdapter/ModifyContentsWithKey] cafejakco.sqlite3 DB 존재하지 않음");
        return;
    }
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        // 에러 날 경우 에러메시지, 어플리케이션 종료 로직 추가해야함
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/ModifyContentsWithKey] Sqlite Open Error");
        return;
    }
    
    sqlite3_stmt *statement;
    char *sql = "UPDATE cafejakco_meta SET key=?, value=? WHERE key=?";
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [key UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"[AppDBAdapter/ModifyContentsWithKey] Sqlite3 Step Error");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}

+ (void)RemoveHeritageWithKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"[AppDBAdapter/RemoveHeritageWithKey] cafejakco.sqlite3 DB 존재하지 않음");
        return;
    }
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        // 에러 날 경우 에러메시지, 어플리케이션 종료 로직 추가해야함
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/RemoveHeritageWithKey] Sqlite Open Error");
        return;
    }
    
    sqlite3_stmt *statement;
    char *sql = "DELETE FROM cafejakco_meta WHERE key=?";
    
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [key UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            NSLog(@"[AppDBAdapter/RemoveHeritageWithKey] Sqlite3 Step Error");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}

+ (NSArray *)GetContentsArray
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"[AppDBAdapter/GetContentsArray] cafejakco.sqlite3 DB 존재하지 않음");
        return NULL;
    }
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        // 에러 날 경우 에러메시지, 어플리케이션 종료 로직 추가해야함
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/GetContentsArray] Sqlite Open Error");
        return NULL;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    sqlite3_stmt *statement;
    char *sql = "SELECT * FROM cafejakco_meta ORDER BY no ASC";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:sqlite3_column_int(statement, 0)], @"no",
                                 [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)], @"key",
                                 [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)], @"value",
                                 nil];
            [resultArray addObject:dic];
        }
    }
    
    return resultArray;
}

+ (NSString *)GetContentWithKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if (![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"[AppDBAdapter/GetContentWithKey] cafejakco.sqlite3 DB 존재하지 않음");
        return NULL;
    }
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK)
    {
        // 에러 날 경우 에러메시지, 어플리케이션 종료 로직 추가해야함
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/GetContentWithKey] Sqlite Open Error");
        return NULL;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    sqlite3_stmt *statement;
    char *sql = "SELECT * FROM cafejakco_meta WHERE key=?";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [[NSString stringWithFormat:@"%@", key] UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:sqlite3_column_int(statement, 0)], @"no",
                                 [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)], @"key",
                                 [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)], @"value",
                                 nil];
            [resultArray addObject:dic];
        }
    }
    
    if ([resultArray count] == 0) {
        return @"NULL";
    }
    return [[resultArray objectAtIndex:0] objectForKey:@"value"];
}

+ (void)RemoveDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if ([fileManager fileExistsAtPath:filePath])
    {
        
        NSError *err;
        if ([fileManager removeItemAtPath:filePath error:&err])
            NSLog(@"[AppDBAdapter/initDB] cafejakco.sqlite3 DB 삭제 완료");
        else
            NSLog(@"[AppDBAdapter/initDB] cafejakco.sqlite3 DB 삭제 실패 : %@", err);
    }
    else
        NSLog(@"[AppDBAdapter/initDB] cafejakco.sqlite3 DB 존재하지 않음");
}

+ (void)AppDBToSession
{
    [AppSession setUsername:[self GetContentWithKey:@"userid"]];
    [AppSession setUsername:[self GetContentWithKey:@"username"]];
    [AppSession setNickname:[self GetContentWithKey:@"nickname"]];
    [AppSession setIsLogin:[self GetContentWithKey:@"islogin"]];
    NSLog(@"[AppDBAdapter/AppDBToSession] DB 정보 Session으로 기록완료");
}
+ (void)AppSessionToDB
{
    NSString *userid = [AppSession getUserId];
    [self UpdateContentsWithKey:@"userid" value:userid];
    [self UpdateContentsWithKey:@"username" value:[AppSession getUsername]];
    [self UpdateContentsWithKey:@"nickname" value:[AppSession getNickname]];
    [self UpdateContentsWithKey:@"islogin" value:[AppSession getIsLogin]];
    NSLog(@"[AppDBAdapter/AppDBToSession] Session 정보 DB로 기록완료");
    
}

@end
