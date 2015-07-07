//
//  SharedDatabaseManager.m
//  testClasses
//
//  Created by Yifang Zhang on 7/2/15.
//  Copyright (c) 2015 Yifang. All rights reserved.
//

#import "SharedDatabaseManager.h"

@implementation SharedDatabaseManager

- (id) init{
    NSLog(@"init started");
    self = [super init];
    if(self != nil){
        self.database = [[DBManager alloc] initWithDatabaseFilename:@"hands.sql"];
        self.dataTableStatus = -1;
    }
    NSLog(@"init ended");
    return self;
}

- (NSInteger) initalizeTable{
    NSLog(@"table init started");
    if(self.dataTableStatus < 0){
    
        NSString * query = @"CREATE TABLE tableTester(id INT  PRIMARY KEY  NOT NULL, user TEXT NOT NULL, message TEXT NOT NULL, swapp_coin INT NOT NULL)";
        [self.database executeQuery:query];
        self.dataTableStatus = 0;
        
        NSLog(@"did the initalization");
        return 1; //did init the table
        
    }
    else{
        NSLog(@"database is already exist");
        return 0; //have already init the table
    }

}
//
- (NSInteger) insertItemIntoTablewithuserID: (NSString *) userID andUser: (NSString *)username andMessage: (NSString *) message andSwappCoin: (NSString *) swappCoin{

    NSLog(@"insert started");
    if (self.dataTableStatus < 0) {
        return -1;
    } else {
        NSString * query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO tableTester(id, user, message, swapp_coin) VALUES (%@, '%@', '%@', %@)", userID, username, message, swappCoin];
        [self.database executeQuery:query];
        
        if (self.dataTableStatus == 0) {
            self.dataTableStatus = 1;
        }
        
        return 0;
    }
    
}
//
- (NSArray *) selectItemFromTable{
    
    if (self.dataTableStatus <= 0) {
        NSLog(@"no data actually");
        return nil;
    } else {
        NSString * query = [NSString stringWithFormat:@"SELECT * FROM tableTester"];
        return [self.database loadDataFromDB:query];
    }
    
}
//
- (NSInteger) dropTable{

    return -1;
}




@end
