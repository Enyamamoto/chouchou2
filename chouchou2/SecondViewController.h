//
//  SecondViewController.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/04.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Member.h"


@interface SecondViewController : UIViewController<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

//データを取得するときに必要なオブジェクト
@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
//データを管理（CRUD)で必要なオブジェクト
@property(strong,nonatomic)NSManagedObjectContext * managedObjectContext;
//ViewControllerで何番目がおされたか
@property(nonatomic,assign) int selectNum;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *secondTable;

@end
