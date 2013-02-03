//
//  ViewController.h
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 02.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ContentView.h"
#import "SupportDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "Mechanism.h"

@interface ViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate, ContentViewDelegate, SupportDetailsDelegate>
{
    ContentView *contentView;
    Mechanism *mechanism;
}

@property (nonatomic, strong) ContentView *contentView;
@property (nonatomic, strong) Mechanism *mechanism;

@end
