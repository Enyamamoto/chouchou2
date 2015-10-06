//
//  MemberViewController.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MemberViewController : UIViewController<UINavigationControllerDelegate>{
    NSString *_assetsUrl;//assetsUrlを格納するインスタンス
    ALAssetsLibrary *_library;//ALAssetsLibraryのインスタンス
}
@property (weak, nonatomic) IBOutlet UITextField *nameText;
- (IBAction)endNameText:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
- (IBAction)tapCameraBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)tapSaveBtn:(id)sender;

@end
