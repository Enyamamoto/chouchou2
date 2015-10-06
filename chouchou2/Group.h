//
//  Group.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/06.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSNumber * id;

@end
