//
//  AboutViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 1/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface AboutViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic,retain) TPKeyboardAvoidingScrollView *scroller;
@property (nonatomic,retain) IBOutlet UIView *scrollView;

@end
