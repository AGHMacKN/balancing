//
//  Mechanism.h
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 04.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CorrectionMass, Rod, Support;

@interface Mechanism : NSManagedObject

@property (nonatomic, retain) NSNumber * mechanismID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *rods;
@property (nonatomic, retain) NSSet *supports;
@property (nonatomic, retain) NSSet *correctionMasses;
@end

@interface Mechanism (CoreDataGeneratedAccessors)

- (void)addRodsObject:(Rod *)value;
- (void)removeRodsObject:(Rod *)value;
- (void)addRods:(NSSet *)values;
- (void)removeRods:(NSSet *)values;

- (void)addSupportsObject:(Support *)value;
- (void)removeSupportsObject:(Support *)value;
- (void)addSupports:(NSSet *)values;
- (void)removeSupports:(NSSet *)values;

- (void)addCorrectionMassesObject:(CorrectionMass *)value;
- (void)removeCorrectionMassesObject:(CorrectionMass *)value;
- (void)addCorrectionMasses:(NSSet *)values;
- (void)removeCorrectionMasses:(NSSet *)values;

@end
