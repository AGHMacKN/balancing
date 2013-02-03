//
//  SupportDetailsViewController.m
//  Balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 22.12.2012.
//  Copyright (c) 2012 AGDev. All rights reserved.
//

#import "SupportDetailsViewController.h"
#import "Support.h"
#import "Rod.h"
#import "AppDelegate.h"

@interface SupportDetailsViewController ()
{
    NSInteger selectedCell;
}

@property (nonatomic) NSInteger selectedCell;

@end

@implementation SupportDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rollerSupport = NO;
        self.selectedCell = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(highlightButton:) withObject:nil afterDelay:0.0];
    // Do any additional setup after loading the view from its nib.
    self.coordTableView.scrollEnabled = NO;
}

- (IBAction)rollerSupportButtonTouched:(id)sender
{
    self.rollerSupport = YES;
    [self performSelector:@selector(highlightButton:) withObject:nil afterDelay:0.0];
}

- (IBAction)pinnedSupportButtonTouched:(id)sender
{
    self.rollerSupport = NO;
    [self performSelector:@selector(highlightButton:) withObject:nil afterDelay:0.0];
}

- (void)highlightButton:(UIButton *)button
{
    if (self.rollerSupport)
    {
        [self.rollerSupportButton setHighlighted:YES];
        [self.pinnedSupportButton setHighlighted:NO];
    }
    else
    {
        [self.rollerSupportButton setHighlighted:NO];
        [self.pinnedSupportButton setHighlighted:YES];
    }
    
}

- (IBAction)done:(id)sender
{
    if (self.selectedCell != -1)
    {
        CGPoint point;
        
        if (self.selectedCell == 0) {
            Rod *tempRod = (Rod *)[[self.delegate currentMechanismRods] objectAtIndex:0];
            point = CGPointMake([tempRod.xA floatValue], [tempRod.yA floatValue]);
        }
        else {
            Rod *tempRod = (Rod *)[[self.delegate currentMechanismRods] objectAtIndex:[[self.delegate currentMechanismRods] count]-1];
            point = CGPointMake([tempRod.xB floatValue], [tempRod.yB floatValue]);
        }
        
        NSString *type;
        if (self.rollerSupport)
            type = @"Roller";
        else
            type = @"Grounded";
        
        [self.delegate createSupportWithType:type atPoint:point];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertView *noSelectedCoordinatesAlert = [[UIAlertView alloc] initWithTitle:@"Where do you want to place the support?"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Select"
                                                    otherButtonTitles:nil, nil];
        [noSelectedCoordinatesAlert show];

    }
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.coordTableView.frame.size.height/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    CGPoint point = [(NSValue *)[self.rodEndPointsArray objectAtIndex:indexPath.row] CGPointValue];
//    cell.textLabel.text = [NSString stringWithFormat: @"x: %0.1f y: %0.1f", point.x, point.y];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Begining of the mechanism";
    }
    else {
        cell.textLabel.text = @"End of the mechanism";
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell = indexPath.row;
}


@end
