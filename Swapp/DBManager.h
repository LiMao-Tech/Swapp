//
//  DBManager.h
//  SQLite3
//
//  Created by Tailung on 2014/11/11.
//  Copyright (c) 2014年 Tailung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (strong, nonatomic) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
