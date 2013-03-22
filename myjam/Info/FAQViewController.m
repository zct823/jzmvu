//
//  FAQViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 1/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "FAQViewController.h"
#import "AppDelegate.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = @"FAQ";
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
    
    //[self.scroller setContentSize:self.contentView.frame.size];
    //[self.scroller addSubview:self.contentView];
    
    NSString *urlAddress = @"http://jam-bu.com/api/content/faq.php";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
    [[self.webView scrollView] setBounces:NO];
    //[self.scroller setContentSize:self.scrollView.frame.size];
    [self.view addSubview:self.webView];
}

//- (void)webViewDidFinishLoad:(UIWebView *)wView {
//    [wView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"];
//    [wView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.zoom= '0.5'"];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!mydelegate.isMustCloseSidebar) {
        [mydelegate openSidebar];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
