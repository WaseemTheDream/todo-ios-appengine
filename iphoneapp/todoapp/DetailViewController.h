//
//  DetailViewController.h
//  todoapp
//
//  Created by Waseem Ahmad on 10/6/13.
//  Copyright (c) 2013 COMP 446. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
