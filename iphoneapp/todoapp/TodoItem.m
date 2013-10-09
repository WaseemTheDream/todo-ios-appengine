//
//  TodoItem.m
//  todoapp
//
//  Created by Waseem Ahmad on 10/6/13.
//  Copyright (c) 2013 COMP 446. All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem

#define TODO_ENDPOINT_URL "http://localhost:15080/todo"

- (id)initWithTitle: (NSString *)title {     // designated initializer
    self = [super init];
    
    if (self && title) {
        self.title = title;
        self.done = NO;
        self.key = @"";
    }
    
    return self;
}

- (NSString *)description
{
    if (self.done == YES) {
        return [self.title stringByAppendingString:@" (done)"];
    } else {
        return self.title;
    }
}

- (NSDictionary *)toDictionary
{
    return @{@"key": self.key,
             @"title": self.title,
             @"done": [NSNumber numberWithBool:self.done]};
}

- (BOOL)save
{
    NSString *method;
    if ([self.key isEqualToString:@""]) {
        method = @"POST";
    } else {
        method = @"PUT";
    }
    NSLog(@"Saving Todo");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@TODO_ENDPOINT_URL]
                                                           cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:method];
    NSError *error;
    NSDictionary *itemDictionary = [self toDictionary];
    NSLog(@"Created item dictionary: %@", itemDictionary);
    NSData *todoData = [NSJSONSerialization dataWithJSONObject:itemDictionary
                                                       options:0
                                                         error:&error];
    [request setHTTPBody:todoData];
    NSError *requestError;
//        NSURLResponse *urlResponse = nil;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSLog(@"Status Code: %lu", [urlResponse statusCode]);
    if ([urlResponse statusCode] != 200) return NO;
    NSLog(@"URL Response: %@", urlResponse);
    NSLog(@"Todo saved");
    NSDictionary *todoDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&requestError];
    NSLog(@"todoDictionary: %@", todoDictionary);
    self.key = [todoDictionary valueForKey:@"key"];
    return YES;
}

- (BOOL)delete
{
    if ([self.key isEqualToString:@""]) {
        NSLog(@"Object key not defined");
        return NO;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@TODO_ENDPOINT_URL]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"DELETE"];
    NSError *error;
    NSDictionary *itemDictionary = [self toDictionary];
    NSData *todoData = [NSJSONSerialization dataWithJSONObject:itemDictionary
                                                       options:0
                                                         error:&error];
    [request setHTTPBody:todoData];
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse
                                      error:&requestError];
    if ([urlResponse statusCode] != 200) return NO;
    NSLog(@"Successfully deleted");
    return YES;
}

+ (NSMutableArray *)collectionFromServer
{
    NSLog(@"Fetching data");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@TODO_ENDPOINT_URL]
                                                           cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSLog(@"Fetched data");
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:response1
                                                                   options:NSJSONReadingMutableLeaves
                                                                     error:&requestError];
    NSLog(@"%@", dataDictionary);
    NSArray *todoDicts = [dataDictionary objectForKey:@"todos"];
    NSMutableArray *collection = [[NSMutableArray alloc] init];
    for (NSDictionary *todoDict in todoDicts) {
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem.title = [todoDict objectForKey:@"title"];
        todoItem.done = [[todoDict objectForKey:@"done"] boolValue];
        todoItem.key = [todoDict objectForKey:@"key"];
        [collection addObject:todoItem];
    }
    
    return collection;
}

@end
