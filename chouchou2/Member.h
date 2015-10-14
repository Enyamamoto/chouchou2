//
//  Member.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/14.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group;

@interface Member : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Group *group;

@end
