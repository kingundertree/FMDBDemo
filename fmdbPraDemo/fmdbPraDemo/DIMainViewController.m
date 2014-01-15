//
//  DIMainViewController.m
//  fmdbPraDemo
//
//  Created by 夏至 on 13-12-22.
//  Copyright (c) 2013年 dooioo. All rights reserved.
//

#import "DIMainViewController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define IOS7_SDK_AVAILABLE 1
#endif
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface DIMainViewController ()

@end

@implementation DIMainViewController
@synthesize listTable,listData,dbPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if (IOS7_SDK_AVAILABLE) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }

    [super viewDidLoad];
    self.navigationItem.title = @"fmdbPraDemo";
    self.view.backgroundColor = [UIColor lightGrayColor];
	// Do any additional setup after loading the view.
    listData = [[NSMutableArray alloc] init];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundColor:[UIColor blackColor]];
    [btn1 addTarget:self action:@selector(createTab:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(20, 20, 80, 35);
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"createTab" forState:UIControlStateNormal];
    [self.view addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundColor:[UIColor blackColor]];
    [btn2 addTarget:self action:@selector(insertData:) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(120, 20, 80, 35);
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"insertData" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn6 setBackgroundColor:[UIColor blackColor]];
    [btn6 addTarget:self action:@selector(updateData:) forControlEvents:UIControlEventTouchUpInside];
    btn6.frame = CGRectMake(220, 20, 80, 35);
    [btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn6 setTitle:@"updateData" forState:UIControlStateNormal];
    [self.view addSubview:btn6];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setBackgroundColor:[UIColor blackColor]];
    [btn3 addTarget:self action:@selector(queryData:) forControlEvents:UIControlEventTouchUpInside];
    btn3.frame = CGRectMake(20, 75, 80, 35);
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitle:@"queryData" forState:UIControlStateNormal];
    [self.view addSubview:btn3];

    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setBackgroundColor:[UIColor blackColor]];
    [btn4 addTarget:self action:@selector(clearData:) forControlEvents:UIControlEventTouchUpInside];
    btn4.frame = CGRectMake(120, 75, 80, 35);
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitle:@"clearData" forState:UIControlStateNormal];
    [self.view addSubview:btn4];

    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 setBackgroundColor:[UIColor blackColor]];
    [btn5 addTarget:self action:@selector(multithread:) forControlEvents:UIControlEventTouchUpInside];
    btn5.frame = CGRectMake(220, 75, 80, 35);
    [btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn5 setTitle:@"multithread" forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    
    listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 380) style:UITableViewStylePlain];
    listTable.showsVerticalScrollIndicator = YES;
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorColor = [UIColor whiteColor];
    [self.view addSubview:listTable];
    
    NSString * doc = PATH_OF_DOCUMENT;
    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
}
#pragma mark - SQL Operations
-(void)createTab:(UIButton *)btn{
    NSLog(@"createTab");
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'user' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }
}
-(void)updateData:(UIButton *)btn{
    NSLog(@"updateData");
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"UPDATE user SET name = ? WHERE name = ? ",@"夏至ing",@"夏至"];
        if (!res) {
            NSLog(@"updateSuc");
        }else{
            NSLog(@"updateFaile");
        }
    }
    [db close];
    [listData removeAllObjects];
}
-(void)insertData:(UIButton *)btn{
    NSLog(@"insertData");
    static int idx = 1;
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"insert into user (name, password) values(?, ?) ";
        NSString * name = [NSString stringWithFormat:@"夏至-->>%d", idx++];
        BOOL res = [db executeUpdate:sql, name, @"123456qp"];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
            NSLog(@"succ to insert data");
        }
        [db close];
    }
}
-(void)queryData:(UIButton *)btn{
    NSLog(@"queryData");
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        [listData removeAllObjects];
        NSString * sql = @"select * from user";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int userId = [rs intForColumn:@"id"];
            NSString * name = [rs stringForColumn:@"name"];
            NSString * pass = [rs stringForColumn:@"password"];
            NSLog(@"user id = %d, name = %@, pass = %@", userId, name, pass);
            
            [listData addObject:[NSString stringWithFormat:@"%d--%@--%@",userId,name,pass]];
        }
        NSLog(@"listData-->>%@",listData);
        [listTable reloadData];
        [db close];
    }
}
-(void)clearData:(UIButton *)btn{
    NSLog(@"clearData");
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        //        NSString * sql = @"delete from user";
        //        BOOL res = [db executeUpdate:sql];
        BOOL res = [db executeUpdate:@"DELETE FROM user WHERE name = ?",@"夏至ing"];

        if (!res) {
            NSLog(@"error to delete db data");
        } else {
            NSLog(@"succ to deleta db data");
        }
        [listData removeAllObjects];
        [listTable reloadData];
        [db close];
    }
}
-(void)multithread:(UIButton *)btn{
    NSLog(@"multithread");
    FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    
    dispatch_async(q1, ^{
        for (int i = 0; i < 5; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"夏至"];
                BOOL res = [db executeUpdate:sql, name, @"123456qp"];
                if (!res) {
                    NSLog(@"error to add db data: %@", name);
                } else {
                    NSLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (int i = 0; i < 5; ++i) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString * sql = @"insert into user (name, password) values(?, ?) ";
                NSString * name = [NSString stringWithFormat:@"xiazer--%d", i];
                BOOL res = [db executeUpdate:sql, name, @"123123qp"];
                if (!res) {
                    NSLog(@"error to add db data: %@", name);
                } else {
                    NSLog(@"succ to add db data: %@", name);
                }
            }];
        }
    });
}
#pragma mark -
#pragma mark Table View Data Source Methods
//返回行数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [listData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

//新建某一行并返回
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
