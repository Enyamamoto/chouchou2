//
//  MemberViewController.m
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import "MemberViewController.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ライブラリオブジェクトの初期化
    if (_library == nil) {
        _library = [[ALAssetsLibrary alloc] init];
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
}
@end
