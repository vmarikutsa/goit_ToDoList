//
//  ToDoItemsListViewController.m
//  ToDoList
//
//  Created by Kirill Kirikov on 8/10/16.
//  Copyright © 2016 Seductive Mobile. All rights reserved.
//

#import "ToDoItemsListViewController.h"
#import "ToDoItemsStore.h"
#import <UIKit/UISwipeGestureRecognizer.h>
#import "MyCell.h"

@interface ToDoItemsListViewController() <UITableViewDataSource, UITableViewDelegate, MyCellDelegate>
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextFIeld;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changePriorityBtn;
@property (nonatomic, strong) id<ToDoItemsStoreProtocol> store;
@property () int numberPriority;
@property (strong) NSArray <NSString *> *captions;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *deleteSwipe;
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
    
    self.deleteSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    //[self.tableView setEditing:YES animated:YES];
    self.tableView.allowsMultipleSelection = NO;
}

- (void) touchedPriorityChangeButton:(MyCell *)cell{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    ToDoItem *currentItem = [[self.store items] objectAtIndex:indexPath.row];
    
    currentItem.priority = [self getNextPriority:currentItem.priority];
    
    //[cell.changePriorityButton setImage:[self getImageWithPriority:currentItem.priority] forState:UIControlStateNormal];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (PriorityType) getNextPriority:(PriorityType)currentpriority {
    PriorityType newPriority = PriorityTypeDefault;
    if (currentpriority == PriorityTypeDefault) {
        newPriority = PriorityTypeLow;
    } else if (currentpriority == PriorityTypeLow) {
        newPriority = PriorityTypeHigh;
    } else if (currentpriority == PriorityTypeHigh) {
        newPriority = PriorityTypeUrgent;
    } else if (currentpriority == PriorityTypeUrgent) {
        newPriority = PriorityTypeDefault;
    } else {
        newPriority = PriorityTypeDefault;
    }
    
    return newPriority;
}

- (UIImage*) getImageWithPriority:(PriorityType)priority {
    UIImage *image;
    
    image = [[UIImage imageNamed:@"PriorityTypeUrgent"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return image;
}


#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoItem *item = [[self.store items] objectAtIndex:indexPath.row];
    item.isDone = !item.isDone;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        ToDoItem *item = [[self.store items] objectAtIndex:indexPath.row];
        [self.store removeItem:item];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.store itemsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCell"];
    }
    ToDoItem *item = [[self.store items] objectAtIndex:indexPath.row];
    //cell.textLabel.text = item.title;
    //cell.detailTextLabel.text = item.summary;
    MyCell *myCell = (MyCell *) cell;
    myCell.titleTextField.text = item.title;
    myCell.summaryLabel.text = item.summary;
    
    /*cell.accessoryType = item.isDone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.backgroundColor = [self getColorWithPriority:item.priority];
    return cell;*/
    
    myCell.accessoryType = item.isDone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    myCell.backgroundColor = [self getColorWithPriority:item.priority];
    myCell.titleTextField.backgroundColor = [self getColorWithPriority:item.priority];
    [myCell.changePriorityButton setImage:[self getImageWithPriority:item.priority] forState:UIControlStateNormal];
    myCell.delegate = self;
    return myCell;
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

/*- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *a = @"a";
}
 

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
   NSString *a = @"a";
}*/


@end
