//
//  Member.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/06.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Member : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * group_id;
@property (nonatomic, retain) NSString * name;

@end
