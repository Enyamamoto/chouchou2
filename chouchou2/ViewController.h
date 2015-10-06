//
//  ViewController.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/04.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Group.h"

@interface ViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

//データを取得するときに必要なオブジェクト
@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
//データを管理（CRUD)で必要なオブジェクト
@property(strong,nonatomic)NSManagedObjectContext * managedObjectContext;

@property (nonatomic,assign)int areaNum;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)tapAddBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *groupText;
- (IBAction)endGroupText:(id)sender;
- (IBAction)tapDetailBtn:(id)sender;


@end

