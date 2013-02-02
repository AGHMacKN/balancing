//
//  ViewController.m
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 02.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import "ViewController.h"
#import "Rod.h"
#import "Support.h"

@interface ViewController ()
{
    UIActionSheet *addActionSheet;
    NSManagedObjectContext *managedObjectContext;
    
}

@property (nonatomic, strong) UIActionSheet *addActionSheet;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation ViewController

@synthesize contentView;
@synthesize mechanism;
@synthesize addActionSheet;
@synthesize managedObjectContext;

- (id)init
{
    self = [super init];
    if (self) {
        self.contentView = [ContentView new];
        self.contentView.delegate = self;
        self.contentView.mechanism = self.mechanism;
        self.view = self.contentView;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                 target:self
                                                 action:@selector(presentActionSheet)];
        
        UIBarButtonItem *calculateButton = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Calculate correction masses"
                                            style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(calculate)];
        
        UIBarButtonItem *mechanismsButton = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Mechanisms list"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(showMechanismsList)];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Save Mechanism"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(saveMechanism)];
        
        NSArray *rightBarButtonItemsArray = [[NSArray alloc] initWithObjects:
                                             calculateButton, saveButton, mechanismsButton, nil];
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItemsArray;
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentActionSheet
{
//    NSString *actionSheetTitle = @"Action Sheet Titile"; //Action Sheet Title
//    NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
    if (!self.addActionSheet.isVisible) {
        NSString *other1 = @"Add support";
        NSString *other2 = @"Edit element";
        NSString *cancelTitle = @"Cancel";
        self.addActionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
        [self.addActionSheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
    }
    else {
        [self.addActionSheet dismissWithClickedButtonIndex:self.addActionSheet.cancelButtonIndex animated:YES];
    }
}

- (void)showMechanismsList
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Add support"]) {
        NSLog(@"Other 1 pressed");
    }
    if ([buttonTitle isEqualToString:@"Edit element"]) {
        NSLog(@"Other 2 pressed");
    }
}

#pragma mark - ContentViewDelegate

- (void)createRodWithMass:(int)mass aPoint:(CGPoint)aPoint bPoint:(CGPoint)bPoint
{
    Rod *newRod = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Rod"
                   inManagedObjectContext:self.managedObjectContext];
    newRod.xA = [NSNumber numberWithFloat:aPoint.x];
    newRod.yA = [NSNumber numberWithFloat:aPoint.y];
    newRod.xB = [NSNumber numberWithFloat:bPoint.x];
    newRod.yB = [NSNumber numberWithFloat:bPoint.y];
    newRod.mass = [NSNumber numberWithFloat:mass];
    newRod.number = [NSNumber numberWithInt:[[self.mechanism.rods allObjects] count] + 1];
    newRod.mechanism = self.mechanism;
    
    [self.mechanism addRodsObject:newRod];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self.view setNeedsDisplay];
}

@end
