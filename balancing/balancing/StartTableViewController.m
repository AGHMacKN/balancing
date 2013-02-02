//
//  StartTableViewController.m
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 02.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "StartTableViewController.h"
#import "ViewController.h"
#import "Mechanism.h"

@interface StartTableViewController ()
{
    NSArray *mechanisms;
}

@property (nonatomic, strong) NSArray *mechanisms;

@end

@implementation StartTableViewController

@synthesize managedObjectContext;
@synthesize mechanisms;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // let's fetch mechanisms from CoreData
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mechanism"
                                                   inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        self.mechanisms = [[NSArray alloc] initWithArray:fetchedObjects];
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mechanisms count] + 1;  // + 1 for the create mechanism row
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 100;
    else
        return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        cell.textLabel.text = @"+   Create new mechanism";
    }
    
    else {
        Mechanism *tempMechanism = [self.mechanisms objectAtIndex:indexPath.row -1];
        cell.textLabel.text = tempMechanism.name;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *vC = [ViewController new];
    if (indexPath.row == 0)
    {
        Mechanism *newMechanism = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Mechanism"
                                   inManagedObjectContext:self.managedObjectContext];
        newMechanism.mechanismID = [NSNumber numberWithInt:[self.mechanisms count] + 1];
        vC.mechanism = newMechanism;
    }
    else
    {
        vC.mechanism = [self.mechanisms objectAtIndex:indexPath.row - 1];
    }
    [self.navigationController pushViewController:vC animated:YES];
}

@end
