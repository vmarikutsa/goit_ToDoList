//
//  ToDoItem.h
//  ToDoList
//
//  Created by Kirill Kirikov on 8/10/16.
//  Copyright © 2016 Seductive Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (assign) BOOL isDone;
@end
