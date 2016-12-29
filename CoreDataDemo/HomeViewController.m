//
//  HomeViewController.m
//  CoreDataDemo
//
//  Created by henghui on 2016/12/25.
//  Copyright © 2016年 henghui. All rights reserved.
//

#import "HomeViewController.h"
#import <CoreData/CoreData.h>
#import "SpiderMan+CoreDataProperties.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *ageData;


@property (strong, nonatomic) NSManagedObjectContext *context;  // 上下文
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel; // 数据模型
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator; //

@end

@implementation HomeViewController

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)ageData{
    
    if (!_ageData) {
        
        self.ageData = [NSMutableArray array];
    }
    return _ageData;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}
// 同样使用懒加载创建
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        
        // 创建 coordinator 需要传入 managedObjectModel
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        // 指定本地的 sqlite 数据库文件
        NSURL *sqliteURL = [[self documentDirectoryURL] URLByAppendingPathComponent:@"CoreDataDemo.sqlite"];
        
        NSLog(@"%@",sqliteURL);
        
        NSError *error;
        
        // 为 persistentStoreCoordinator 指定本地存储的类型，这里指定的是 SQLite
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:sqliteURL
                                                        options:nil
                                                          error:&error];
        if (error) {
            NSLog(@"falied to create persistentStoreCoordinator %@", error.localizedDescription);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        // 指定 context 的并发类型： NSMainQueueConcurrencyType 或 NSPrivateQueueConcurrencyType
        _context = [[NSManagedObjectContext alloc ] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _context;
}

// 用来获取 document 目录
- (nullable NSURL *)documentDirectoryURL {
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setCoreData{
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}


#pragma mark - add data
- (IBAction)addButton:(UIButton *)sender {
    
    SpiderMan *spiderMan = [NSEntityDescription insertNewObjectForEntityForName:@"SpiderMan" inManagedObjectContext:self.context];
    
    spiderMan.name = [NSString stringWithFormat:@"spiderman%u",arc4random()%100];
    spiderMan.sex = @"man";
    spiderMan.age = arc4random()%100;
    spiderMan.height = arc4random()%100;
    
    NSError *error;
    
    [self.context save:&error];
    
     NSLog(@"增：***name:%@--age:%hd---sex:%@",spiderMan.name,spiderMan.age,spiderMan.sex);
    
    [self.dataSource addObject:spiderMan.name];
    
    [self.ageData addObject:[NSString stringWithFormat:@"%hd",spiderMan.age]];
    
    NSLog(@"增：￥￥￥dataSource:%@*****ageData:%@",self.dataSource,self.ageData);
    
    [self.tableView reloadData];
    
}


#pragma mark - change data
- (IBAction)changeButton:(UIButton *)sender {
    
    [self.dataSource removeAllObjects];
    
    [self.ageData removeAllObjects];
    
    NSFetchRequest *fetchRequest = [SpiderMan fetchRequest]; // 自动创建的 NSManagedObject 子类里会生成相应的 fetchRequest 方法
    // 也可以使用这种方式：[NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age > %@", @(1)];
    
    NSArray<NSSortDescriptor *> *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    //
    NSArray<SpiderMan *> *students = [self.context executeFetchRequest:fetchRequest error:nil];

    
    for (SpiderMan *spiderMan in students) {
        
        spiderMan.name = [NSString stringWithFormat:@"superman%u",arc4random()%100];
        
        NSLog(@"改:***name:%@--age:%hd---sex:%@",spiderMan.name,spiderMan.age,spiderMan.sex);
        
        [self.dataSource addObject:spiderMan.name];
        
        [self.ageData addObject:[NSString stringWithFormat:@"%hd",spiderMan.age]];
    }
    
    [self.context save:nil];
    
    [self.tableView reloadData];
}


#pragma mark - delete data
- (IBAction)deleteButton:(UIButton *)sender {
    
    [self.dataSource removeAllObjects];
    
    [self.ageData removeAllObjects];
    
    NSFetchRequest *fetchRequest = [SpiderMan fetchRequest]; // 自动创建的 NSManagedObject 子类里会生成相应的 fetchRequest 方法
    // 也可以使用这种方式：[NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age > %@", @(1)];
    
    NSArray<NSSortDescriptor *> *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    //
    NSArray<SpiderMan *> *students = [self.context executeFetchRequest:fetchRequest error:nil];

    for (SpiderMan *spiderMan in students) {
        
        [self.context deleteObject:spiderMan];
        
        NSLog(@"删:***name:%@--age:%hd---sex:%@",spiderMan.name,spiderMan.age,spiderMan.sex);
        
        [self.dataSource addObject:spiderMan.name];
        
        [self.ageData addObject:[NSString stringWithFormat:@"%hd",spiderMan.age]];
    }
    [self.context save:nil]; // 最后不要忘了调用 save 使操作生效。
    
    [self.tableView reloadData];
}


- (IBAction)searchButton:(UIButton *)sender {
    
    [self.dataSource removeAllObjects];
    
    [self.ageData removeAllObjects];

    
    NSFetchRequest *fetchRequest = [SpiderMan fetchRequest]; // 自动创建的 NSManagedObject 子类里会生成相应的 fetchRequest 方法
    // 也可以使用这种方式：[NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age > %@", @(1)];
    
    NSArray<NSSortDescriptor *> *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    //
    NSArray<SpiderMan *> *students = [self.context executeFetchRequest:fetchRequest error:nil];
    
    for (SpiderMan *spiderman in students) {
        
        NSLog(@"查***name:%@--age:%hd---sex:%@",spiderman.name,spiderman.age,spiderman.sex);
        
        [self.dataSource addObject:spiderman.name];
        
        [self.ageData addObject:[NSString stringWithFormat:@"%hd",spiderman.age]];
    }
    
    [self.tableView reloadData];

    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%ld",self.dataSource.count);
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource) {
        
    
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.textLabel.text = self.dataSource[indexPath.row];
    
        cell.detailTextLabel.text = self.ageData[indexPath.row];
    
//    cell.textLabel.text = @"spiderman";
    
        return cell;
    
    }else{
        
        return [[UITableViewCell alloc]init];
    }
    
    
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
