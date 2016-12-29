//
//  SpiderMan+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by henghui on 2016/12/25.
//  Copyright © 2016年 henghui. All rights reserved.
//

#import "SpiderMan+CoreDataProperties.h"

@implementation SpiderMan (CoreDataProperties)

+ (NSFetchRequest<SpiderMan *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SpiderMan"];
}

@dynamic age;
@dynamic height;
@dynamic name;
@dynamic sex;

@end
