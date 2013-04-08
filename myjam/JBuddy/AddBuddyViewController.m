//
//  AddBuddyViewController.m
//  myjam
//
//  Created by Mohd Hafiz on 4/1/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "AddBuddyViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BuddyCell.h"
#import "ASIWrapper.h"

#define kBuddyCellHeight 64

@interface AddBuddyViewController ()

@end

@implementation AddBuddyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tableData = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tapSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSearchBuddy)];
    [self.searchButtonView setUserInteractionEnabled:YES];
    [self.searchButtonView addGestureRecognizer:tapSearch];
    [tapSearch release];
    
    self.searchTextField.delegate = self;
}

- (void)handleSearchBuddy
{
    [self.loadingIndicator startAnimating];
    [self.searchTextField resignFirstResponder];
    [self performSelector:@selector(processSearch) withObject:nil afterDelay:0.5];
}

- (void)processSearch
{
    if ([tableData count] > 0) {
        [tableData removeAllObjects];
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/buddy_search.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"search\":\"%@\"}",self.searchTextField.text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"request %@\n%@\n\nresponse data: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        if ([status isEqualToString:@"ok"])
        {
            for (id data in [resultsDictionary objectForKey:@"list"])
            {
                [tableData addObject:data];
            }
            
        }
        
    }
    
    [resultsDictionary release];
    
    if ([tableData count] > 0) {
        [self.tableView setHidden:NO];
        [self.noRecordLabel setHidden:YES];
    }else{
        [self.noRecordLabel setHidden:NO];
        [self.tableView setHidden:YES];
    }

    [self.tableView reloadData];
    [self.loadingIndicator stopAnimating];
}

#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BuddyCell";
    
    BuddyCell *cell = (BuddyCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuddyCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *cellData = [tableData objectAtIndex:indexPath.row];
    
    NSLog(@"cell data %@",cellData);
    [cell.usernameLabel setTextColor:[UIColor colorWithHex:@"#D22042"]];
    cell.usernameLabel.text = [cellData valueForKey:@"username"];
    cell.statusLabel.text = [cellData valueForKey:@"status"];
    
    [cell.userImageView setImageWithURL:[NSURL URLWithString:[cellData valueForKey:@"image"]]
                       placeholderImage:[UIImage imageNamed:@"blank_avatar"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  if (!error) {
                                      
                                  }else{
                                      NSLog(@"error retrieve image: %@",error);
                                  }
                                  
                              }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tapped at index %d",indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBuddyCellHeight;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_searchTextField release];
    [_searchButtonView release];
    [_tableView release];
    [_fbPhoneSearchView release];
    [_fbButton release];
    [_phonebookButton release];
    [_loadingIndicator release];
    [_noRecordLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSearchTextField:nil];
    [self setSearchButtonView:nil];
    [self setTableView:nil];
    [self setFbPhoneSearchView:nil];
    [self setFbButton:nil];
    [self setPhonebookButton:nil];
    [self setLoadingIndicator:nil];
    [self setNoRecordLabel:nil];
    [super viewDidUnload];
}
@end
