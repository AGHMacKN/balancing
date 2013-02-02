//
//  ContentView.h
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 02.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Mechanism.h"

@protocol ContentViewDelegate
@optional
- (void)createRodWithMass:(int)mass aPoint:(CGPoint)aPoint bPoint:(CGPoint)bPoint;
@end

@interface ContentView : UIView
{
    __unsafe_unretained id <ContentViewDelegate> delegate;
    Mechanism *mechanism;
}

@property (assign, nonatomic) id <ContentViewDelegate> delegate;
@property (nonatomic, strong) Mechanism *mechanism;

@end
