//
//  SecondViewController.m
//  chouchou2
//
//  Created by 山本　援 on 2015/10/04.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Member.h"
#import "MemberViewController.h"


@interface SecondViewController (){
    NSMutableArray *_memberArray;
    NSMutableArray *_memberList;
    AppDelegate *_appdelegete;
    
    NSArray *_ary;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ナビゲーションコントローラーにエリア名を指定
    self.navigationItem.title = @"Members";
    
//    self.navigationController.delegate = self;
    
    _memberList = [NSMutableArray array];
    
    _appdelegete = [[UIApplication sharedApplication] delegate];

    //配列を更新
    [self getFriendsInAreaSelected];
    NSLog(@"memberList %@",_memberList);
    
    NSLog(@"viewDidLoad");
    NSLog(@"もらった行番号=%d",self.selectNum);
    
    
    self.secondTable.delegate = self;
    self.secondTable.dataSource = self;
    
    //_memberList[self.selectNum]; がコアデータだから、Group *groupになる。
    Group *group = _memberList[self.selectNum];
    
    NSLog(@"gr = %@",group);
    
    //tomoの配列にrowがはいる
    //array型に変換
    _ary = [group.member allObjects];
    NSLog(@"ary = %@",_ary);
    
}

//他のviewから復帰した瞬間に発動
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //配列を更新
    [self getFriendsInAreaSelected];

    
    Group *group = _memberList[self.selectNum];
    
    NSLog(@"gr = %@",group);
    
    //tomoの配列にrowがはいる
    _ary = [group.member allObjects];
    NSLog(@"ary = %@",_ary);

    
    // テーブルビューを更新
    [self.secondTable reloadData];
    NSLog(@"viewWillAppear");
}

//selectAlldataで取り出したのを表示するメソッド
-(void)getFriendsInAreaSelected{
    
    //    NSDictionary *options = @{@"group_id":[NSString stringWithFormat:@"%d",self.areaNum]};
    
// もともとあったメソッド
//    _memberArray = [NSMutableArray new];
//    
//    _memberArray = [[self selectAllData:nil] mutableCopy];
    
    _memberList = [[self selectAllData:nil] mutableCopy];
}


////Coredataに入ってるデータを取ってくる
//- (NSArray *)selectAllData:(NSDictionary *)options {
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    
//    //fetch設定を生成
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Member"];
//    
//    
//    //sort条件を設定
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    // managedObjectContextからデータを取得
//    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
//    
//    return results;
//}

//Coredataに入ってるデータを取ってくる
- (NSArray *)selectAllData:(NSDictionary *)options {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //fetch設定を生成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Group"];
    
    
    //sort条件を設定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // managedObjectContextからデータを取得
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    return results;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _memberArray.count;
    return _ary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //定数を宣言（static = 静的)
    static NSString *CellIdentifer = @"Cell";
    
    //セルの再利用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if(cell == nil){
        //セルの初期化とスタイルの決定
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
//    Member *member = _memberArray[indexPath.row];
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",member.name];
    
    Member *member = _ary[indexPath.row];
    cell.textLabel.text = member.name;
    return cell;
}

//ラインみたいなスライド削除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //CoreDataから削除
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        Member *member = _ary[indexPath.row];
        [context deleteObject:member];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"削除完了");
        }
        
        //表示側も配列からデータを削除することでCoreDataの状態を反映
        [_memberArray removeObjectAtIndex:indexPath.row]; // 削除ボタンが押された行のデータを配列から削除します。
        
        //テーブルビューからも消します
        [self.secondTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addBtn:(id)sender {
    
}
@end
