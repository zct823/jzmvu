//
//  CreateBoxViewController.h
//  myjam
//
//  Created by ME-Tech Mac User1 on 22/01/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"

@interface CreateBoxViewController : NewsViewController

@property (retain, nonatomic) NSString *selectedApp;

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern;


@end
