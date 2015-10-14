//
//  AppDelegate.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/04.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//これが複数画面間で共有したい値があるときにつかう
@property (nonatomic) int iPath;
@property (nonatomic) NSString  *team;
@property(nonatomic,assign) int selectNum;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic) NSMutableArray *absentAry;
@property (strong,nonatomic) NSMutableArray *attendAry;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

