//
//  SharedDatabaseManager.h
//  testClasses
//
//  Created by Yifang Zhang on 7/2/15.
//  Copyright (c) 2015 Yifang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface SharedDatabaseManager : NSObject

/* private variables in SharedDBManager */
@property NSInteger dataTableStatus;
@property (strong, nonatomic) DBManager * database;

/* method based on one table */
//
- (NSInteger) initalizeTable;
//
- (NSInteger) insertItemIntoTablewithuserID: (NSString *) userID andUser: (NSString *)username andMessage: (NSString *) message andSwappCoin: (NSString *) swappCoin;
//
- (NSArray *) selectItemFromTable;
//
- (NSInteger) dropTable;

@end
