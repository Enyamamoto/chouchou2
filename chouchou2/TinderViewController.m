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

@interface TinderViewController (){
    NSArray *picurl;
    MDCSwipeToChooseView *_mdview;
    NSMutableArray *_coreAry;
    int _Cnt;
    
    AppDelegate *_appDelegete;
}

@end

@implementation TinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初期化
    _appDelegete = [[UIApplication sharedApplication] delegate];
    
    _coreAry = [NSMutableArray new];
    
    _coreAry = [[self selectAllData:nil] mutableCopy];
    
    _Cnt = 0;
    
    
    //画像urlをまとめて配列にいれる。stringのあつまり
    //おれの場合はここがおそらくカメラロール
//    picurl = [NSArray arrayWithObjects:
//              _coreAry[@"image"][0],
//              _coreAry[@"image"][1],
//              _coreAry[@"image"][2],
//              _coreAry[@"image"][3],
//              nil];
    
    //ログに表示する
    //phpのforeachみたいなもん
    for (Member *member in _coreAry) {
        picurl = [NSArray arrayWithObjects:member.image, nil];
    }
    
    
    //引き出しのない引き出し。NSMutableArrayは追加変更ができる
    _appDelegete.absentAry = [NSMutableArray array];
    _appDelegete.attendAry = [NSMutableArray array];
    
    
}

//Coredataに入ってるデータを取ってくる
- (NSArray *)selectAllData:(NSDictionary *)options {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //fetch設定を生成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Member"];
    
    
    //sort条件を設定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // managedObjectContextからデータを取得
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    return results;
}

-(void)picLoad:(NSArray *)urls
{
    for (int i =0; i<[urls count]; i++) {
        
        //MDCSwipeToChooseViewのオプション設定と作成
        MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
        options.delegate = self;
        //スワイプのときの文字
        options.likedText = @"Attend";
        //カラー指定
        options.likedColor = [UIColor blueColor];
        options.nopeText = @"Absence";
        options.onPan = ^(MDCPanState *state){
            if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
                //                NSLog(@"Let go now to delete the photo!");
            }
        };
        
        //MDCSwipeToChooseViewの位置
        CGRect frame = CGRectMake(0, 0, 320, 240);
        //初期化。初期化したときの位置がframe
        _mdview = [[MDCSwipeToChooseView alloc]initWithFrame:frame options:options];
        //ここで左上ではなくて、画面自体のセンターに指定してる
        _mdview.center = self.view.center;
        
        // 後々removeできるように_mdviewにタグをつけている
        //製造番号みたいなイメージ
        _mdview.tag = (i + 1);
        
        //addsubview読み込んだ画像をのせる
        long int cnt = [urls count]-1;
        NSString *imageStr = [urls objectAtIndex:(cnt-i)];
        
        //一旦viewだけ作っている
        //※ここをカメラロールから引っ張ってくる
        _mdview.imageView.image = [UIImage imageNamed:@"load"];
        [self.view addSubview:_mdview];
        
        UIImage *img = [UIImage imageNamed:imageStr];
        
        //ここで表示
        _mdview.imageView.image = img;
        
        
        //URLからALAssetを取得
        [_library assetForURL:[NSURL URLWithString:_assetsUrl]resultBlock:^(ALAsset *asset){
            //画像があるかチェック
            if (asset) {
                NSLog(@"データがあります");
                //写真データを取得するためのオブジェクト
                ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRep fullScreenImage]];
                _mdview.imageView.image = fullScreenImage;
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
    if(_Cnt < [_coreAry count]){
        //左にスワイプ
        if (direction == MDCSwipeDirectionLeft) {
            //            NSLog(@"Photo deleted!");
            NSString *str = _coreAry[_Cnt][@"name"];
            //ここで欠席に保存してる
            [_appDelegete.absentAry addObject:str];
        } else {
            //右にスワイプ
            //            NSLog(@"Photo saved!");
            NSString *str = _coreAry[_Cnt][@"name"];
            //ここで出席に保存してる
            [_appDelegete.attendAry addObject:str];
        }
        //1回スワイプしたから1こ増える
        _Cnt++;
        if(_Cnt == [_coreAry count]){
            //スワイプし終わったら次の画面
            [self moveToSecond];
            self.memberLabel.text = @"Member Name";
        }else{
            self.memberLabel.text = _coreAry[_Cnt][@"name"];
        }
    }
}

-(void)moveToSecond{
    ResultViewController *SVC = [self.storyboard
                                 instantiateViewControllerWithIdentifier:@"ResultViewController"];
    
    // 遷移する方法を指定して遷移するコードを書く
    //// Modal遷移 下からニュっと出てくる遷移
    //    [self presentViewController:SVC animated:YES completion:nil];
    
    //// Push遷移 横から出てきて横に還っていく遷移
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
    [self picLoad:picurl];          //urlから非同期で画像を読み込む
    _Cnt = 0;
    self.memberLabel.text = _coreAry[_Cnt][@"name"];
}
@end
