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
#import "Group.h"

@interface TinderViewController : UIViewController
<MDCSwipeToChooseDelegate>
@property (weak, nonatomic) IBOutlet UIButton *attendanceBtn;
- (IBAction)tapAttendanceBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;


@end
