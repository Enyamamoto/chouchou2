//
//  ResultViewController.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Member.h"


@interface ResultViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

//データを取得するときに必要なオブジェクト
@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
//データを管理（CRUD)で必要なオブジェクト
@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *resultTable;

@end
