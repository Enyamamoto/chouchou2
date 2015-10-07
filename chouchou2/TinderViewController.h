//
//  TinderViewController.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose.h>
#import "AppDelegate.h"
#import "Member.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TinderViewController : UIViewController
<MDCSwipeToChooseDelegate,NSFetchedResultsControllerDelegate>{
    NSString *_assetsUrl;//assetsUrlを格納するインスタンス
    ALAssetsLibrary *_library;//ALAssetsLibraryのインスタンス
}
//データを取得するときに必要なオブジェクト
@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
//データを管理（CRUD)で必要なオブジェクト
@property(strong,nonatomic)NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic) IBOutlet UIButton *attendanceBtn;
- (IBAction)tapAttendanceBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;


@end
