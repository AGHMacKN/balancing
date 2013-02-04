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
#import "CorrectionMass.h"

#define kFIRST 1000

@interface ViewController ()
{
    UIActionSheet *addActionSheet;
    NSManagedObjectContext *managedObjectContext;
    id lastObject;
    
}

@property (nonatomic, strong) UIActionSheet *addActionSheet;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) id lastObject;

@end

@implementation ViewController

@synthesize contentView;
@synthesize mechanism;
@synthesize addActionSheet;
@synthesize managedObjectContext;
@synthesize lastObject;

- (id)init
{
    self = [super init];
    if (self) {
        self.contentView = [ContentView new];
        self.contentView.delegate = self;
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
        
        UIBarButtonItem *undoButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Undo"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(undoSomething)];
        
        NSArray *rightBarButtonItemsArray = [[NSArray alloc] initWithObjects:
                                             calculateButton, saveButton, mechanismsButton, undoButton, nil];
        
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

- (void)saveMechanism
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIAlertView *mechanismName = [[UIAlertView alloc] initWithTitle:@"Mechanism name"
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Save", nil];
    [mechanismName setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [mechanismName show];
}

- (void)undoSomething
{
    if ([self.lastObject isKindOfClass:[Rod class]]) {
        [self.mechanism removeRodsObject:self.lastObject];
    }
    else if ([self.lastObject isKindOfClass:[Support class]]) {
        [self.mechanism removeSupportsObject:self.lastObject];
    }
    
    [self.view setNeedsDisplay];
}

- (void)calculate
{
    //first check if we can select between partial and full balancing
    if ([self.mechanism.supports count] > 1) {
        
        BOOL isRoller = NO;
        BOOL isGrounded = NO;
        for (Support *support in [self.mechanism.supports allObjects]) {
            if ([support.type isEqualToString:@"Roller"])
                isRoller = YES;
            else
                isGrounded = YES;
        }
        //more logic should go here
    }
    
    for (int i = [self.mechanism.rods count]; i > 0; i--) {
        
        Rod *currentRod = [[self.mechanism.rods allObjects] objectAtIndex: i-1];
        
        CorrectionMass *newCorrectionMass = [NSEntityDescription
                                             insertNewObjectForEntityForName:@"CorrectionMass"
                                             inManagedObjectContext:self.managedObjectContext];
        newCorrectionMass.mass = [NSNumber numberWithInt:2];
        newCorrectionMass.fromA = [NSNumber numberWithBool:YES];
        
        newCorrectionMass.x = currentRod.xA;
        newCorrectionMass.y = currentRod.yA;
        
        int xA = [currentRod.xA intValue];
        int yA = [currentRod.yA intValue];
        int xB = [currentRod.xB intValue];
        int yB = [currentRod.yB intValue];
        
        newCorrectionMass.lenght = [NSNumber numberWithFloat:sqrt((abs(xA) - abs(xB))^2 + (abs(yA) - abs(yB))^2) * [currentRod.previousMass floatValue] + sqrt((abs(xA) - abs(xB))^2 + (abs(yA) - abs(yB))^2)/2 * [currentRod.mass floatValue]];
        
        currentRod.correctionMass = newCorrectionMass;
        newCorrectionMass.rod = currentRod;
        
        Rod *nextRod = [[self.mechanism.rods allObjects] objectAtIndex: i-2];
        nextRod.previousMass = [NSNumber numberWithFloat:[newCorrectionMass.mass floatValue] + [currentRod.mass floatValue]];
    }
    
}

- (void)addSupport
{
    SupportDetailsViewController *sdVC = [SupportDetailsViewController new];
    sdVC.delegate = self;
    sdVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:sdVC animated:YES completion:nil];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Add support"]) {
        [self addSupport];
    }
    if ([buttonTitle isEqualToString:@"Edit element"]) {
        NSLog(@"Edit element pressed");
    }
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Save"])
    {
        UITextField *mechanismName = [alertView textFieldAtIndex:0];
        if (![mechanismName.text isEqualToString:@""]) {
            self.mechanism.name = mechanismName.text;
            
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        
            [alertView dismissWithClickedButtonIndex:alertView.cancelButtonIndex animated:YES];
            [self showMechanismsList];
        }
    }
}

#pragma mark - ContentViewDelegate
- (NSArray *)currentMechanismRods
{
    return [self.mechanism.rods allObjects];
}

- (NSArray *)currentMechanismSupports
{
    return [self.mechanism.supports allObjects];
}

- (NSArray *)currentMechanismCorrectionMasses
{
    return [self.mechanism.correctionMasses allObjects];
}

- (void)createRodWithMass:(int)mass aPoint:(CGPoint)aPoint bPoint:(CGPoint)bPoint
{
    aPoint = [self transformPoint:aPoint];
    bPoint = [self transformPoint:bPoint];
    
    for (Rod *rod in [self.mechanism.rods allObjects]) {
        if ((pow((aPoint.x -[rod.xB floatValue]), 2) +
            pow((aPoint.y - [rod.yB floatValue]), 2)) < pow(30, 2)) {
            
            aPoint.x = [rod.xB floatValue];
            aPoint.y = [rod.yB floatValue];
        }
    }
    
    Rod *newRod = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Rod"
                   inManagedObjectContext:self.managedObjectContext];
    newRod.xA = [NSNumber numberWithFloat:aPoint.x];
    newRod.yA = [NSNumber numberWithFloat:aPoint.y];
    newRod.xB = [NSNumber numberWithFloat:bPoint.x];
    newRod.yB = [NSNumber numberWithFloat:bPoint.y];
    newRod.mass = [NSNumber numberWithFloat:mass];
    newRod.number = [NSNumber numberWithInt:[[self.mechanism.rods allObjects] count] + 1];
    if ([[self.mechanism.rods allObjects] count] == 0) {
        newRod.previousElementNumber = [NSNumber numberWithInt:kFIRST];
    }
    else {
        newRod.previousElementNumber = [NSNumber numberWithInt:[[self.mechanism.rods allObjects] count]];
    }
    newRod.mechanism = self.mechanism;
    self.lastObject = newRod;
    
    [self.mechanism addRodsObject:newRod];
    
    [self.view setNeedsDisplay];
}

- (void)createSupportWithType:(NSString *)type atPoint:(CGPoint)point
{
    //saving the support with CoreData
    Support *newSupport = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Support"
                           inManagedObjectContext:self.managedObjectContext];
    newSupport.x = [NSNumber numberWithFloat:point.x];
    newSupport.y = [NSNumber numberWithFloat:point.y];
    newSupport.type = type;
    self.lastObject = newSupport;
    [self.mechanism addSupportsObject:newSupport];
    
    [self.view setNeedsDisplay];
}

- (CGPoint)transformPoint:(CGPoint)point
{
    CGFloat halfViewX = self.view.frame.size.width/2;
    CGFloat halfViewY = self.view.frame.size.height/2;
    
    if (point.x > halfViewX && point.y < halfViewY) {
        point.x = point.x - halfViewX;
        point.y = halfViewY - point.y;
    }
    else if (point.x > halfViewX && point.y > halfViewY) {
        point.x = point.x - halfViewX;
        point.y = - (point.y - halfViewY);
    }
    else if (point.x < halfViewX && point.y > halfViewY) {
        point.x = - (halfViewX - point.x);
        point.y = - (point.y - halfViewY);
    }
    else {
        point.x = - (halfViewX - point.x);
        point.y = halfViewY - point.y;
    }
    
    return point;
}

@end
