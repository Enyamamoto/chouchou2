//
//  TinderViewController.m
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import "TinderViewController.h"
#import "AppDelegate.h"
#import "ResultViewController.h"
#import "Member.h"
#import "Group.h"

@interface TinderViewController (){
    NSArray *_picurl;
    MDCSwipeToChooseView *_mdview;
    NSMutableArray *_coreAry;
    int _Cnt;
    NSArray *pic;
    AppDelegate *_appDelegete;
    
    NSArray *_memberAry;
    
    NSMutableArray *_groupAry;

    
}

@end

@implementation TinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初期化.intとかfloatとかの数字を扱うもの、stringは初期化必要ない。
    _appDelegete = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"iPath %i",_appDelegete.iPath);
    if (_library == nil) {
    _library = [[ALAssetsLibrary alloc] init];
    }
    
    _coreAry = [NSMutableArray new];
    
    _memberAry = [NSArray new];
    
    _groupAry = [NSMutableArray new];
    
    _groupAry = [[self selectAllData:nil] mutableCopy];
    
    NSLog(@"group = %@",_groupAry);
    
    Group *group = _groupAry[_appDelegete.iPath];
    
    _memberAry = [group.member allObjects];
    NSLog(@"_memberAry = %@",_memberAry);
    
    
    _Cnt = 0;
    

    
    //ログに表示する
    //phpのforeachみたいなもん
    _picurl = [[NSArray alloc]init];
    for (Member *member in _memberAry) {
        _picurl = [_picurl arrayByAddingObject:member.image];
    }
    NSLog (@"picurl = %@",_picurl);

    
    
    //引き出しのない引き出し。NSMutableArrayは追加変更ができる
    _appDelegete.absentAry = [NSMutableArray array];
    _appDelegete.attendAry = [NSMutableArray array];
    
    NSLog(@"_appDelegete.absentAry = %@",_appDelegete.absentAry);
    
    
    //背景画像設定
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"chouchou.png"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
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

-(void)picLoad:(NSArray *)urls
{
    for (int i =0; i<[urls count]; i++) {
        
        //addsubview読み込んだ画像をのせる
        long int cnt = [urls count]-1;
        NSString *imageStr = [urls objectAtIndex:(cnt-i)];
        
        
        
        NSLog(@"iamgestr = %@",imageStr);
        //URLからALAssetを取得
        [_library assetForURL:[NSURL URLWithString:imageStr]resultBlock:^(ALAsset *asset){
            NSLog(@"_library = %@",_library);
            NSLog(@"asset = %@",asset);
            //画像があるかチェック
        if (asset) {
            //MDCSwipeToChooseViewのオプション設定と作成
            MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
            options.delegate = self;
            //スワイプのときの文字
            options.likedText = @"○";
            //カラー指定
            options.likedColor = [UIColor blueColor];
            options.nopeText = @"×";
            options.onPan = ^(MDCPanState *state){
                if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
                    //                NSLog(@"Let go now to delete the photo!");
                }
            };
            
            //MDCSwipeToChooseViewの位置
            CGRect frame = CGRectMake(0, 0, 320, 280);
            //初期化。初期化したときの位置がframe
            _mdview = [[MDCSwipeToChooseView alloc]initWithFrame:frame options:options];
            //ここで左上ではなくて、画面自体のセンターに指定してる
            _mdview.center = self.view.center;
            
            // 後々removeできるように_mdviewにタグをつけている
            //製造番号みたいなイメージ
            _mdview.tag = (i + 1);
            
            NSLog(@"データがあります");
            //写真データを取得するためのオブジェクト
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRep fullScreenImage]];
            _mdview.imageView.image = fullScreenImage;
            
            [self.view addSubview:_mdview];
        }else{
            NSLog(@"データがありません");
        }
        } failureBlock:nil];
    }
}


//ローカル画像の読み込み
-(void)local_picLoad:(NSString *)url
{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:url]];
    iv.frame = self.view.bounds;
    [self.view addSubview:iv];
}


#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
//これは迷ってるときに表示される
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"yes");
        return YES;
    } else {
        NSLog(@"no");
        // Snap the view back and cancel the choice.
        [UIView animateWithDuration:0.16 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.center = [view superview].center;
        }];
        //YESにすると画像がきえる
        return YES;
    }
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    NSString *test;
    
    NSLog(@"_coreAry=%@",_coreAry);
    if(_Cnt < _memberAry.count){
        //1回スワイプしたから1こ増える
        NSLog(@"_Cnt=%i",_Cnt);
        //_Cnt++;
        NSLog(@"_Cnt=%i",_Cnt);
        //ここのindexが0だと、速攻breakになっちゃって一人目がカウントされない
        int index = 0;
        for (NSManagedObject *beforeData in _memberAry) {
            Member *member = (Member *)beforeData;
            NSLog(@"_memberAryのname = %@",member.name);
            test = member.name;
            if (index == _Cnt) {
                break;
            }
            index++;
        }
        
        //左にスワイプ
        if (direction == MDCSwipeDirectionLeft) {
            //            NSLog(@"Photo deleted!");
            NSString *str = test;
            //ここで欠席に保存してる
            [_appDelegete.absentAry addObject:str];
            NSLog(@"欠席 = %@",str);
        } else {
            //右にスワイプ
            //            NSLog(@"Photo saved!");
            NSString *str = test;
            //ここで出席に保存してる
            [_appDelegete.attendAry addObject:str];
            NSLog(@"出席 = %@",str);
        }
        
        //次の人の名前をとるために,_Cnt++とfor文
        _Cnt++;
        index = 0;
        for (NSManagedObject *beforeData in _memberAry) {
            Member *member = (Member *)beforeData;
            NSLog(@"_coreAry.image = %@",member.name);
            test = member.name;
            if (index == _Cnt) {
                break;
            }
            index++;
        }
        
        if(_Cnt == [_memberAry count]){
            //スワイプし終わったら次の画面
            [self moveToSecond];
            self.memberLabel.text = @"Member Name";
        }else{
            self.memberLabel.text = test;
        }
    }
    

}

-(void)moveToSecond{
    ResultViewController *SVC = [self.storyboard
                                 instantiateViewControllerWithIdentifier:@"ResultViewController"];
    
    // 遷移する方法を指定して遷移するコードを書く
    // Push遷移 横から出てきて横に還っていく遷移
    [self.navigationController pushViewController:SVC animated:YES];
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

- (IBAction)tapAttendanceBtn:(id)sender {
    [self local_picLoad:@""];    //最後に表示するローカル画像
    [self picLoad:_picurl];          //urlから非同期で画像を読み込む
    _Cnt = 0;
    NSLog(@"_coreAry=%@",_memberAry);
    NSString *test;
    
    //coredataを使う時は、for in文で抽出してあげないとで−たを普通にはとれない
    int index = 0;
    for (NSManagedObject *beforeData in _memberAry) {
        Member *member = (Member *)beforeData;
        NSLog(@"_coreAry.name = %@",member.name);
        test = member.name;
        if (index == _Cnt) {
            break;
        }
        index++;
        
    }

    self.memberLabel.text = test;

}
@end
