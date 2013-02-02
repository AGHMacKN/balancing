//
//  Support.h
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 02.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Mechanism;

@interface Support : NSManagedObject

@property (nonatomic, retain) NSNumber * nextElementNumber;
@property (nonatomic, retain) NSNumber * previousElementNumber;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Mechanism *mechanism;

@end
