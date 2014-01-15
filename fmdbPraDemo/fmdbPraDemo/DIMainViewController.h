//
//  DIMainViewController.h
//  fmdbPraDemo
//
//  Created by 夏至 on 13-12-22.
//  Copyright (c) 2013年 dooioo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DIMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView *listTable;
@property(strong,nonatomic) NSMutableArray *listData;
@property(strong,nonatomic) NSString *dbPath;
@end
