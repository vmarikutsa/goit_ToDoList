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
@property (weak, nonatomic) IBOutlet UIButton *changePriorityBtn;
@property (nonatomic, strong) id<ToDoItemsStoreProtocol> store;
@property () int numberPriority;
@property (strong) NSArray <NSString *> *captions;
@end

@implementation ToDoItemsListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.store = [[ToDoItemsStore alloc] init];
    [self addItemWithTitle:@"Buy new iPhone" andSummary:@"When iPhone 8 will be available." andPriority:PriorityTypeLow];
    [self addItemWithTitle:@"Sell my Galaxy S7" andSummary:@"Because iPhone is cool!" andPriority:PriorityTypeDefault];
    
    self.numberPriority = 0;
    self.captions = [[NSArray alloc] initWithObjects:@"Default", @"Low", @"High", @"Urgent",nil];
    
    [self changeCaptionPriority];
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
    cell.backgroundColor = [self getColorWithPriority:item.priority];
    return cell;
}

#pragma mark - Actions

- (void) addItemWithTitle:(NSString *)title andSummary:(NSString *)summary andPriority:(PriorityType)priority {
    ToDoItem *item = [[ToDoItem alloc] init];
    item.title = title;
    item.summary = summary;
    item.priority = priority;
    [self.store addItem:item];
};

- (IBAction)didTouchAddButton:(id)sender {
    NSString *title = self.titleTextFIeld.text;
    NSString *summary = self.summaryTextField.text;
    PriorityType priority = [self.changePriorityBtn.currentTitle priorityType];
    [self addItemWithTitle:title andSummary:summary andPriority:priority];
    
    NSUInteger newElementIndex = [self.store itemsCount] - 1;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newElementIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.titleTextFIeld.text = nil;
    self.summaryTextField.text = nil;
    
    self.numberPriority = 0;
    [self changeCaptionPriority];
    
    [self.view endEditing:YES];
}

- (IBAction)changePriority:(UIButton *)sender {
    self.numberPriority += 1;
    [self changeCaptionPriority];
}

- (void) changeCaptionPriority {
    
    NSString *newCaption = self.captions[self.numberPriority % 4];
    [self.changePriorityBtn setTitle:newCaption forState: UIControlStateNormal];
    
    [self.changePriorityBtn setBackgroundColor:[self getColorWithPriority:[self.changePriorityBtn.currentTitle priorityType]]];
}

- (UIColor *) getColorWithPriority:(PriorityType)priority{
    
  // PriorityTypeLow,
  //  ,
  //  PriorityTypeHigh,
    UIColor *color = [UIColor clearColor];
    
    if (priority == PriorityTypeLow) {
        color = [UIColor yellowColor];
    } else if (priority == PriorityTypeHigh) {
        color = [UIColor orangeColor];
    } else if(priority == PriorityTypeUrgent) {
        color = [UIColor redColor];
    };

    return color;
}

@end
