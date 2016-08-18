//
//  ToDoItemsStore.h
//  ToDoList
//
//  Created by Kirill Kirikov on 8/10/16.
//  Copyright © 2016 Seductive Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"

@protocol ToDoItemsStoreProtocol <NSObject>
- (void) addItem:(ToDoItem *)item;
- (void) removeItem:(ToDoItem *)item;
- (NSArray<ToDoItem *> *)items;
- (NSUInteger) itemsCount;
@end

@interface ToDoItemsStore : NSObject <ToDoItemsStoreProtocol>

@end