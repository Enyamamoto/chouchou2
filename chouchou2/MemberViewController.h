//
//  MemberViewController.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreData/CoreData.h>
#import "Member.h"
#import "SecondViewController.h"


@interface MemberViewController : UIViewController<UINavigationControllerDelegate,NSFetchedResultsControllerDelegate>{
    NSString *_assetsUrl;//assetsUrlを格納するインスタンス
    ALAssetsLibrary *_library;//ALAssetsLibraryのインスタンス
   
}

//データを取得するときに必要なオブジェクト
@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
//データを管理（CRUD)で必要なオブジェクト
@property(strong,nonatomic)NSManagedObjectContext * managedObjectContext;
@property(nonatomic,assign) int selectNum;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
- (IBAction)endNameText:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
- (IBAction)tapCameraBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)tapSaveBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;

@end
