//
//  SpiderMan+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by henghui on 2016/12/25.
//  Copyright © 2016年 henghui. All rights reserved.
//

#import "SpiderMan+CoreDataClass.h"

 
NS_ASSUME_NONNULL_BEGIN

@interface SpiderMan (CoreDataProperties)

+ (NSFetchRequest<SpiderMan *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nonatomic) int16_t height;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *sex;

@end

NS_ASSUME_NONNULL_END
