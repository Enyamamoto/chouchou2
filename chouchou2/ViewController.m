//
//  ViewController.m
//  chouchou2
//
//  Created by 山本　援 on 2015/10/04.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import "ViewController.h"
//遷移したい画面
#import "SecondViewController.h"
#import "TinderViewController.h"
#import "AppDelegate.h"
#import "Group.h"

@interface ViewController (){
    NSMutableArray *_groupArray;
    
    AppDelegate *_appdelegate;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     [self getFriendsInAreaSelected];
    
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    
}


//selectAlldataで取り出したのを表示するメソッド
-(void)getFriendsInAreaSelected{
    
//    NSDictionary *options = @{@"group_id":[NSString stringWithFormat:@"%d",self.areaNum]};
    _groupArray = [NSMutableArray new];
    
    _groupArray = [[self selectAllData:nil] mutableCopy];
    
}


//Coredataに入ってるデータを取ってくる
- (NSArray *)selectAllData:(NSDictionary *)options {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //fetch設定を生成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Group"];
    
    // optionの指定があった場合には、指定されたオプションを設定する
//    if (options) {
//        if ([[options valueForKey:@"includesPropertyValues"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
//            [fetchRequest setIncludesPropertyValues:NO];
//        }else{
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"group_id = %@",[options objectForKey:@"group_id"]]];
//            [fetchRequest setPredicate:predicate];
//        }
//    }
    
    //sort条件を設定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // managedObjectContextからデータを取得
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    return results;
}

//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count;
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //定数を宣言（static = 静的)
    static NSString *CellIdentifer = @"Cell";
    
    //セルの再利用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    if(cell == nil){
        //セルの初期化とスタイルの決定
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    Group *group = _groupArray[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",group.groupName];
    return cell;
}


//ラインみたいなスライド削除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //CoreDataから削除
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        Group *group = _groupArray[indexPath.row];
        [context deleteObject:group];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"削除完了");
        }
        
        //表示側も配列からデータを削除することでCoreDataの状態を反映
        [_groupArray removeObjectAtIndex:indexPath.row]; // 削除ボタンが押された行のデータを配列から削除します。
        
        //テーブルビューからも消します
        [self.mainTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // ここは空のままでOKです。
    }
}

//タップした時の処理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%liがタップされたよ",indexPath.row);
    _appdelegate.iPath = (int)indexPath.row;
    NSLog(@"デリゲートのiPath = %i",_appdelegate.iPath);
    //遷移したい先のviewcontrollerを指定
    TinderViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"TinderViewController"];
    //Push遷移
    [self.navigationController pushViewController:VC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//追加ボタンが押されたとき
- (IBAction)tapAddBtn:(id)sender {
    //グループの追加
    // AppDelegateで宣言されているCoreData用のManagedObjectContextを取得
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // インサートしたいデータを作成
    //textviewに入力された名前
    NSString *name = self.groupText.text;
//    NSDate *created = [NSDate new];
//    NSNumber *group_id = [NSNumber numberWithInt:self.areaNum];
    
    
    // CoreDataにデータを保存する
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
    
    [group setGroupName:name];
//    [group setCreated:created];
//    [group setGroup_id:group_id];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"保存成功");
        
        //配列を更新
        [self getFriendsInAreaSelected];
        
        // テーブルビューを更新
        [self.mainTable reloadData];
    }
}
- (IBAction)endGroupText:(id)sender {
}

//members画面に遷移
- (IBAction)tapDetailBtn:(id)sender {
    
    NSLog(@"buttonYpush");
    //ボタンでindexPathRowを取得
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    int row = (int)[self.mainTable indexPathForCell:cell].row;
    NSLog(@"indexpath?:%d",row);
    SecondViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    //押された番号を遷移先画面のプロパティにセット
    //dvc.selectNumとindexPath.rowは型が違うので型を変換する
    VC.selectNum = row;
    //Push遷移
    [self.navigationController pushViewController:VC animated:YES];
}
@end
