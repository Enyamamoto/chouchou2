//
//  ResultViewController.m
//  chouchou2
//
//  Created by 山本　援 on 2015/10/05.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import "ResultViewController.h"
#import "AppDelegate.h"
#import "Member.h"


@interface ResultViewController (){

    NSMutableArray *_attendAry;
    NSMutableArray *_absentAry;
    AppDelegate *_appDelegete;
}

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDid起動");
    // Do any additional setup after loading the view.
    
    _appDelegete = [[UIApplication sharedApplication] delegate];
    
    self.resultTable.delegate = self;
    self.resultTable.dataSource = self;
    
    _attendAry = [NSMutableArray arrayWithArray:_appDelegete.attendAry];
    _absentAry = [NSMutableArray arrayWithArray:_appDelegete.absentAry];
    
    _appDelegete.attendAry = [NSMutableArray array];
    _appDelegete.absentAry = [NSMutableArray array];
    
    _resultTable.rowHeight = 57.0;
    _resultTable.sectionHeaderHeight = 57.0;
    
    //背景画像
    UIImage *background = [UIImage imageNamed:@"chouchou.png"];
    self.resultTable.backgroundView = [[UIImageView alloc] initWithImage:background];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"chouchou.png"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
}


//tableViewとcellの背景を透明にしてる
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // セクション数を設定
    return 2;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *title;
//    switch (section) {
//        case 0:
//            title = @"Presence";
//            break;
//        case 1:
//            title = @"Absence";
//            break;
//        default:
//            break;
//    }
//    return title;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *l = [UILabel new];
    if (section == 0) {
    l.backgroundColor = [UIColor grayColor];
    l.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
    l.text = [NSString stringWithFormat:@"Presence"];
    l.textColor = [UIColor whiteColor];
    }else{
        l.backgroundColor = [UIColor grayColor];
        l.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
        l.text = [NSString stringWithFormat:@"Absence"];
        l.textColor = [UIColor whiteColor];
    }
    return l;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int i;
    
    if(_attendAry.count == 0){
        switch (section) {
            case 0:
                i = 1;
                break;
            case 1:
                i = (int)[_absentAry count];
                NSLog(@"absentCnt %li",(long)_absentAry.count);
                break;
            default:
                break;
        }
    }else if(_absentAry.count == 0){
        switch (section) {
            case 0:
                i = (int)[_attendAry count];
                NSLog(@"attendCnt %li",(long)_attendAry.count);
                break;
            case 1:
                i = 1;
                break;
            default:
                break;
        }
    }else if(_attendAry.count != 0 && _absentAry.count != 0){
        switch (section) {
            case 0:
                i = (int)[_attendAry count];
                NSLog(@"atcnt %li",_attendAry.count);
                break;
            case 1:
                i = (int)[_absentAry count];
                NSLog(@"abCnt %li",_absentAry.count);
                break;
            default:
                break;
        }
    }
    
    return i;
}

//行に表示するデータを表示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(_absentAry.count == 0){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = _attendAry[indexPath.row];
                cell.textLabel.textColor = [UIColor blueColor];
                cell.textLabel.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
                
                break;
            case 1:
                cell.textLabel.text = @"Nothing";
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
                break;
            default:
                break;
        }
    }else if(_attendAry.count == 0){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = @"Nothing";
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
                break;
            case 1:
                cell.textLabel.text = _absentAry[indexPath.row];
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
                
                break;
            default:
                break;
        }
        
    }else if(_attendAry.count != 0 && _absentAry.count != 0){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = _attendAry[indexPath.row];
                cell.textLabel.textColor = [UIColor blueColor];
                cell.textLabel.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
                break;
            case 1:
                cell.textLabel.text = _absentAry[indexPath.row];
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.font = [UIFont fontWithName:@"Walt Disney Script v4.1" size:35.0];
                break;
            default:
                break;
        }
    }
    return cell;
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

@end
