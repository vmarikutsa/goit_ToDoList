//
//  ToDoItem.m
//  ToDoList
//
//  Created by Kirill Kirikov on 8/10/16.
//  Copyright © 2016 Seductive Mobile. All rights reserved.
//

#import "ToDoItem.h"

@implementation NSString (priorityType)

- (PriorityType) priorityType {
    if ([self isEqualToString : @"Low"]) {
        return PriorityTypeLow;
    } else if ([self isEqualToString : @"Default"]) {
        return PriorityTypeDefault;
    } else if ([self isEqualToString : @"High"]) {
        return PriorityTypeHigh;
    } else if ([self isEqualToString : @"Urgent"]) {
        return PriorityTypeUrgent;
    } else {
        return PriorityTypeDefault;
    }
}
@end

@implementation ToDoItem

@end
