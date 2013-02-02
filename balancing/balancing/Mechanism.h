//
//  Mechanism.h
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 02.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mechanism : NSManagedObject

@property (nonatomic, retain) NSNumber * mechanismID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *rods;
@property (nonatomic, retain) NSSet *supports;
@end

@interface Mechanism (CoreDataGeneratedAccessors)

- (void)addRodsObject:(NSManagedObject *)value;
- (void)removeRodsObject:(NSManagedObject *)value;
- (void)addRods:(NSSet *)values;
- (void)removeRods:(NSSet *)values;

- (void)addSupportsObject:(NSManagedObject *)value;
- (void)removeSupportsObject:(NSManagedObject *)value;
- (void)addSupports:(NSSet *)values;
- (void)removeSupports:(NSSet *)values;

@end
