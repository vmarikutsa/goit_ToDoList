//
//  MyCell.h
//  ToDoList
//
//  Created by Ivan on 8/21/16.
//  Copyright © 2016 Seductive Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCell;

@protocol MyCellDelegate <NSObject>

- (void) touchedPriorityChangeButton:(MyCell *)cell;

@end

@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *changePriorityButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak,nonatomic) id<MyCellDelegate> delegate;
@end
