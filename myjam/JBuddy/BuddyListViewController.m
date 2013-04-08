//
//  ChatListViewController.m
//  myjam
//
//  Created by Mohd Hafiz on 3/29/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "BuddyListViewController.h"
#import "ASIWrapper.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kBuddyCellHeight 64

@interface BuddyListViewController ()

@end

@implementation BuddyListViewController


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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableData = [[NSMutableArray alloc] init];
    copyListOfItems = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self retrieveDataFromAPI];
    [self.tableView reloadData];
    searching = NO;
    selectRowEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tableData removeAllObjects];
}

- (void)retrieveDataFromAPI
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/buddy_list.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = @"";
    
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
                [self.tableData addObject:data];
            }
            
        }
        
    }
    
    [resultsDictionary release];
}

#pragma mark -
#pragma mark SearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    selectRowEnabled = NO;
//    self.tableView.scrollEnabled = NO;
    [self.searchBar setShowsCancelButton:YES animated:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    searching = NO;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    [copyListOfItems removeAllObjects];
    
    if([searchText length] > 0) {
        
        searching = YES;
        selectRowEnabled = YES;
//        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        searching = NO;
        selectRowEnabled = NO;
//        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void) searchTableView {
    
    NSString *searchText = self.searchBar.text;
    
    for (id row in self.tableData) {
        NSString *username = [row objectForKey:@"username"];
        NSRange titleResultsRange = [username rangeOfString:searchText options:NSCaseInsensitiveSearch];

        if (titleResultsRange.length > 0)
            [copyListOfItems addObject:row];
    }
}


#pragma mark -
#pragma mark TableView delegate

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(selectRowEnabled)
        return indexPath;
    else
        return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int totalRow;
    
    if (searching){
        totalRow = [copyListOfItems count];
    }
    else {
        totalRow = [self.tableData count];
    }
    
    if (totalRow)
    {
        [self.tableView setHidden:NO];
        [self.recordLabel setHidden:YES];
    }else{
        [self.tableView setHidden:YES];
        [self.recordLabel setHidden:NO];
    }
    
    return totalRow;
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

    NSDictionary *cellData = nil;
    if (searching) {
        cellData = [copyListOfItems objectAtIndex:indexPath.row];
    }else{
        cellData = [self.tableData objectAtIndex:indexPath.row];
    }
    
    NSLog(@"cell data %@",cellData);
    
    cell.buddyUserId = [cellData valueForKey:@"buddy_user_id"];
    cell.usernameLabel.text = [cellData valueForKey:@"username"];
    cell.statusLabel.text = [cellData valueForKey:@"status"];
    [cell.timeLabel setHidden:YES];
    [cell.dateLabel setHidden:YES];
    if ([cell.statusLabel.text isEqualToString:@"Pending Approval"]) {
        [cell.usernameLabel setTextColor:[UIColor colorWithHex:@"#00CC66"]];
        cell.statusLabel.text = @"Requested an invite. Accept?";
        
        [cell.approveButtonsView setHidden:NO];
        cell.noButton.tag = cell.buddyUserId;
        cell.yesButton.tag = cell.buddyUserId;
        [cell.noButton addTarget:self action:@selector(handleNotApproveButtons:) forControlEvents:UIControlEventTouchUpInside];
        [cell.yesButton addTarget:self action:@selector(handleApproveButtons:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([cell.statusLabel.text isEqualToString:@"Buddy Request Sent"]) {
        [cell.usernameLabel setTextColor:[UIColor colorWithHex:@"#00CC66"]];
        cell.statusLabel.text = @"*Pending invite";
        
    }
    
    [cell.usernameLabel setTextColor:[UIColor colorWithHex:@"#D22042"]];

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

- (void)handleApproveButtons:(UIButton *)button
{
    NSLog(@"YES");
}

- (void)handleNotApproveButtons:(UIButton *)button
{
    NSLog(@"NO");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_searchBar release];
    [_recordLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setRecordLabel:nil];
    [super viewDidUnload];
}
@end
