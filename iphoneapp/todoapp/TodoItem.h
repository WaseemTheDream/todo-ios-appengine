//
//  TodoItem.h
//  todoapp
//
//  Created by Waseem Ahmad on 10/6/13.
//  Copyright (c) 2013 COMP 446. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject

+ (NSMutableArray *)collectionFromServer;

- (id)initWithTitle: (NSString *)title;
- (BOOL)save;
- (BOOL)delete;

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL done;

@property (nonatomic, strong) NSString *description;

@end
