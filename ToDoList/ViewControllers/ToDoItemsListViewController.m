//
//  ToDoItemsListViewController.m
//  ToDoList
//
//  Created by Kirill Kirikov on 8/10/16.
//  Copyright © 2016 Seductive Mobile. All rights reserved.
//

#import "ToDoItemsListViewController.h"
#import "ToDoItemsStore.h"

@interface ToDoItemsListViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextFIeld;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) id<ToDoItemsStoreProtocol> store;
@end

@implementation ToDoItemsListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.store = [[ToDoItemsStore alloc] init];
    [self addItemWithTitle:@"Buy new iPhone" andSummary:@"When iPhone 8 will be available."];
    [self addItemWithTitle:@"Sell my Galaxy S7" andSummary:@"Because iPhone is cool!"];
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoItem *item = [[self.store items] objectAtIndex:indexPath.row];
    item.isDone = !item.isDone;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.store itemsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    ToDoItem *item = [[self.store items] objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.summary;
    cell.accessoryType = item.isDone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Actions

- (void) addItemWithTitle:(NSString *)title andSummary:(NSString *)summary {
    ToDoItem *item = [[ToDoItem alloc] init];
    item.title = title;
    item.summary = summary;
    [self.store addItem:item];
};

- (IBAction)didTouchAddButton:(id)sender {
    NSString *title = self.titleTextFIeld.text;
    NSString *summary = self.summaryTextField.text;
    [self addItemWithTitle:title andSummary:summary];
    
    NSUInteger newElementIndex = [self.store itemsCount] - 1;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newElementIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.titleTextFIeld.text = nil;
    self.summaryTextField.text = nil;
    
    [self.view endEditing:YES];
}

@end
