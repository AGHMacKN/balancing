//
//  Rod.h
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 03.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Mechanism;

@interface Rod : NSManagedObject

@property (nonatomic, retain) NSNumber * mass;
@property (nonatomic, retain) NSNumber * nextElementNumber;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * previousElementNumber;
@property (nonatomic, retain) NSNumber * xA;
@property (nonatomic, retain) NSNumber * xB;
@property (nonatomic, retain) NSNumber * yA;
@property (nonatomic, retain) NSNumber * yB;
@property (nonatomic, retain) NSNumber * bPointMass;
@property (nonatomic, retain) Mechanism *mechanism;

@end
