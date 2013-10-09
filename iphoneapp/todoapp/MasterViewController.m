//
//  MasterViewController.m
//  todoapp
//
//  Created by Waseem Ahmad on 10/6/13.
//  Copyright (c) 2013 COMP 446. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "TodoItem.h"

@interface MasterViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray *todoItems;
@end

@implementation MasterViewController

- (NSMutableArray *)todoItems
{
    if (!_todoItems) _todoItems = [TodoItem collectionFromServer];
    return _todoItems;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1) {
        return;
    }
    NSLog(@"Clicked create button");
    NSString *title = [[alertView textFieldAtIndex:0] text];
    NSLog(@"%@", title);
    TodoItem *item = [[TodoItem alloc] initWithTitle:title];
    
    if (item && [item save]) {
        [self.todoItems insertObject:item atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodoItem *item = [self.todoItems objectAtIndex:indexPath.item];
    NSLog(@"Item selected: %@", item);
    item.done = !item.done;
    if ([item save]) {
        [tableView cellForRowAtIndexPath:indexPath].textLabel.text = [item description];
    }
}



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(askForInput)];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)askForInput
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Todo"
                                                    message:@"Please enter the todo item below"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Create", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"todo Items count: %lu", self.todoItems.count);
    return self.todoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    TodoItem *item = self.todoItems[indexPath.row];
    cell.textLabel.text = [item description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TodoItem *todoItem = [self.todoItems objectAtIndex:indexPath.row];
        if ([todoItem delete]) {
            [self.todoItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TodoItem *item = self.todoItems[indexPath.row];
        [[segue destinationViewController] setDetailItem:item];
    }
}

@end
