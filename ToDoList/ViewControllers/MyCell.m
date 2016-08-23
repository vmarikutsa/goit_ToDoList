//
//  MyCell.m
//  ToDoList
//
//  Created by Ivan on 8/21/16.
//  Copyright © 2016 Seductive Mobile. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchChangePriorityButton:(UIButton *)sender {
   [self.delegate touchedPriorityChangeButton:self];
}
- (IBAction)changeTitleAfterEditing:(UITextField *)sender {
    [self.delegate editingTitleCell:self];
}

@end
