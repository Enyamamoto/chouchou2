//
//  Group.h
//  chouchou2
//
//  Created by 山本　援 on 2015/10/14.
//  Copyright (c) 2015年 En Yamamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSSet *member;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addMemberObject:(Member *)value;
- (void)removeMemberObject:(Member *)value;
- (void)addMember:(NSSet *)values;
- (void)removeMember:(NSSet *)values;

@end
