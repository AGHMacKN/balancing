//
//  CorrectionMass.h
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 04.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rod;

@interface CorrectionMass : NSManagedObject

@property (nonatomic, retain) NSNumber * lenght;
@property (nonatomic, retain) NSNumber * mass;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * fromA;
@property (nonatomic, retain) Rod *rod;

@end
