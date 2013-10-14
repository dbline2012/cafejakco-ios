//
//  AppDBAdapter.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 30..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "AppDBAdapter.h"
#import <sqlite3.h>

@implementation AppDBAdapter

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"cafejakco.sqlite3"];
    
    // 디비 파일 존재하면 리턴
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"[AppDBAdapter/initDB] DB Table 존재");
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
    
    char *sql = "CREATE TABLE cafejakco_meta (no INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, key CHAR, value CHAR, c);"\
    //"CREATE INDEX IND_itemNm_ctrdNm ON heritageTable(itemNm, ctrdNm)";
    "CREATE INDEX IND_key ON cafejakco_meta(key)";
    
    if (sqlite3_exec(database, sql, nil, nil, nil) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSLog(@"[AppDBAdapter/initDB] Query Error");
        return;
    }
    NSLog(@"[AppDBAdapter/initDB] DB Table 생성");
    sqlite3_close(database);
}

@end
