//
//  SupportDetailsViewController.h
//  Balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 22.12.2012.
//  Copyright (c) 2012 AGDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SupportDetailsDelegate
@optional
- (void)createSupportWithType:(NSString *)type atPoint:(CGPoint)point;
- (NSArray *)currentMechanismRods;
@end

@interface SupportDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __unsafe_unretained id <SupportDetailsDelegate> delegate;
    UITableView *coordTableView;
    UIButton *rollerSupportButton;
    UIButton *pinnedSupportButton;
    BOOL rollerSupport;
}

@property (assign, nonatomic) id <SupportDetailsDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *coordTableView;
@property (nonatomic, retain) IBOutlet UIButton *rollerSupportButton;
@property (nonatomic, retain) IBOutlet UIButton *pinnedSupportButton;
@property (nonatomic) BOOL rollerSupport;

- (IBAction)done:(id)sender;
- (IBAction)rollerSupportButtonTouched:(id)sender;
- (IBAction)pinnedSupportButtonTouched:(id)sender;
- (IBAction)cancel:(id)sender;

@end
