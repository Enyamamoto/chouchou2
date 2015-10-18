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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // セクション数を設定
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    switch (section) {
        case 0:
            title = @"出席";
            break;
        case 1:
            title = @"欠席";
            break;
        default:
            break;
    }
    return title;
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
                cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20.0];
                
                break;
            case 1:
                cell.textLabel.text = @"Nothing";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20.0];
                break;
            default:
                break;
        }
    }else if(_attendAry.count == 0){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = @"Nothing";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20.0];
                break;
            case 1:
                cell.textLabel.text = _absentAry[indexPath.row];
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20.0];
                
                break;
            default:
                break;
        }
        
    }else if(_attendAry.count != 0 && _absentAry.count != 0){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = _attendAry[indexPath.row];
                cell.textLabel.textColor = [UIColor blueColor];
                cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20.0];
                break;
            case 1:
                cell.textLabel.text = _absentAry[indexPath.row];
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20.0];
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
