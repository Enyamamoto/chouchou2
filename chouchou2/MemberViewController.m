//
//  MemberViewController.m
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import "MemberViewController.h"
//データを扱うために
#import "AppDelegate.h"
#import "Member.h"
#import "SecondViewController.h"
#import "Group.h"

@interface MemberViewController (){
    AppDelegate *_appdelegate;
    
    NSMutableArray *_groupArray;
}

@end

@implementation MemberViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ライブラリオブジェクトの初期化
    if (_library == nil) {
        _library = [[ALAssetsLibrary alloc] init];
    }

    
    //Appdelegate初期化
    _appdelegate = [[UIApplication sharedApplication]delegate];
    

    //背景画像設定
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"chouchou.png"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
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

- (IBAction)tapCameraBtn:(id)sender {
    //イメージピッカーの生成
    //機能のタイプをせっていする
    //初期化
    UIImagePickerControllerSourceType sourcetype = -1;
    //定数に近いもともと割り振られてるナンバー
    //実はUIImagePickerControllerSourceTypePhotoLibraryには単純に1,2とかがわり振られてるが、数字だとわかりにくいので名前をつけている
    sourcetype = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //カメラロール機能が使えなかったら処理を中止する
    if(![UIImagePickerController isSourceTypeAvailable:sourcetype]){
        return;//何もせずに終わっちゃう
    }
    
    //イメージピッカーの生成
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourcetype;
    imagePicker.delegate = (id)self;
    
    //イメージピッカー表示
    //モーラル指定→presentViewController
    [self presentViewController:imagePicker animated:YES completion:nil];
    //上記まででカメラロール表示
}


//写真を選んだ時
-(void)imagePickerController:(UIImagePickerController *)
picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //カメラライブラリから選んだ写真のURLを取得
    _assetsUrl = [(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
    
    //URLからALAssetを取得
    [_library assetForURL:[NSURL URLWithString:_assetsUrl]resultBlock:^(ALAsset *asset){
        //画像があるかチェック
        if (asset) {
            NSLog(@"データがあります");
            //写真データを取得するためのオブジェクト
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRep fullScreenImage]];
            self.myImage.image = fullScreenImage;
        }else{
            NSLog(@"データがありません");
        }
    } failureBlock:nil];
    
    //元の画面に戻る
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)endNameText:(id)sender {
}
- (IBAction)tapSaveBtn:(id)sender {
    //グループの追加
    // AppDelegateで宣言されているCoreData用のManagedObjectContextを取得
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // インサートしたいデータを作成
    //textviewに入力された名前
    NSString *name = self.nameText.text;
    NSString *image = _assetsUrl;
    
    // CoreDataにデータを保存する
    Member *member = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:context];
    
//    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
//    
//    NSLog(@"group = %@",group);
    [self getFriendsInAreaSelected];
    NSLog(@"_gropu %@",_groupArray);

    
    [member setName:name];
    [member setImage:image];
    
    
    Group *group = _groupArray[_appdelegate.selectNum];
    
    NSLog(@"gr = %@",group);

    //tomoの配列にrowがはいる
    [group addMemberObject:member];
    
    NSArray *ary = [group.member allObjects];
    NSLog(@"ary = %@",ary);
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"保存成功");
    }
    
    //この一行でもどるボタン。子画面を閉じる。(Modalの画面遷移用)。completionは完了時どうしたいかを設定できる。
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    
    
    //sort条件を設定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // managedObjectContextからデータを取得
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    return results;
}

- (IBAction)cancelBtn:(id)sender {
    
[self dismissViewControllerAnimated:YES completion:nil];
}
@end
