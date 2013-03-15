//
//  ShopListViewController.m
//  myjam
//
//  Created by Azad Johari on 1/29/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ShopListViewController.h"
#define kTableCellHeight 170

@interface ShopListViewController ()

@end

@implementation ShopListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
}

- (void)refresh {
    [self.activityIndicator startAnimating];
    [self performSelector:@selector(addItem) withObject:nil afterDelay:0.0];
}

- (void)loadData
{
    [self setupView];
}

- (void)addItem { /* add item to top */
    
//    [self loadData];
    [self setupView];
    
   // self.pageCounter = 1;
    [self.catArray removeAllObjects];
    //    [aQRcodeType removeAllObjects];
    self.catArray = [[MJModel sharedInstance] getCategoryAndTopShop];
    [self.tableView reloadData];
    
    [self stopLoading];
//    [self.activityIndicatorView setHidden:YES];
}

- (void)setupView
{
    self.selectedCategories = @"";
    self.searchedText = @"";
    
    NSArray *list = [[MJModel sharedInstance] getCategoryAndTopShop];
    
    if ([list count] > 0) {
        [self.tableData addObjectsFromArray:list];
    }
    
    self.tableData = [list mutableCopy];
    
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
    [self.activityIndicatorView setHidden:YES];
    
    if (![self.tableData count]) {
        [self.activityIndicator setHidden:YES];
        [self.activityIndicatorView setHidden:NO];
        [self.loadingLabel setText:@"Request timed out. Pull to refresh."];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Bottom Loadmore action

//- (void) addItemsToEndOfTableView{
//    //    [super addItemsToEndOfTableView];
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        
//        CGRect screenBounds = [[UIScreen mainScreen] bounds];
//        if (screenBounds.size.height != 568) {
//            // code for 4-inch screen
//            [self.tableView setContentOffset:CGPointMake(0, 0)];
//            
//            
//            
//        }}];
//}

- (void) addItemsToEndOfTableView{
    //    [super addItemsToEndOfTableView];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.pageCounter >= self.totalPage)
        {
            
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            if (screenBounds.size.height != 568) {
                // code for 4-inch screen
                [self.tableView setContentOffset:CGPointMake(0, 0)];
                
            }
            
        }else if (self.pageCounter < self.totalPage){
            self.pageCounter++;
            NSArray *list = [[MJModel sharedInstance] getCategoryAndTopShop];
            
            if ([list count] > 0) {
                [self.tableData addObjectsFromArray:list];
            }
            
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return  [_catArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(ShopTableViewCell *)cell
{
    cell.contentView.backgroundColor = [UIColor clearColor];
    CGSize expectedLabelSize  = [[[_catArray objectAtIndex:indexPath.section] valueForKey:@"category_name"] sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(150.0, cell.catNameLabel.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame = cell.catNameLabel.frame;
    newFrame.size.width = expectedLabelSize.width;
    cell.catNameLabel.text =[[_catArray objectAtIndex:indexPath.section] valueForKey:@"category_name"];
    cell.catNameLabel.frame = newFrame;
    if ([[[_catArray objectAtIndex:indexPath.section] valueForKey:@"category_shop_count"] integerValue] <4){
        cell.viewAllButton.hidden = YES;
        cell.middleLine.frame = CGRectMake(expectedLabelSize.width+50,cell.middleLine.frame.origin.y,300-expectedLabelSize.width-50, 1);
    }
    else{
        cell.middleLine.frame = CGRectMake(expectedLabelSize.width+50,cell.middleLine.frame.origin.y,300-expectedLabelSize.width-120, 1);
        cell.viewAllButton.tag = indexPath.section;
        [cell.viewAllButton addTarget:self action:@selector(viewAll:) forControlEvents:UIControlEventTouchUpInside];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    cell.catLabel1.text = [[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:0] valueForKey:@"shop_name"];
    cell.shopLabel1.hidden = NO;
    if([[[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:0] valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
        cell.topLabel1.hidden=NO;
    }
    cell.shopLabel1.text =[[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:0] valueForKey:@"shop_category"];
    cell.button1.tag =  3*indexPath.section+0;
    
    [cell.button1 setBackgroundImageWithURL:[NSURL URLWithString:[[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:0] valueForKey:@"shop_logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
 
    

    [cell.button1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] count] >1){
        cell.catLabel2.text = [[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:1] valueForKey:@"shop_name"];
        cell.shopLabel2.text =[[[[_catArray objectAtIndex:indexPath.section]valueForKey:@"shop_list"] objectAtIndex:1] valueForKey:@"shop_category"];
        cell.shopLabel2.hidden = NO;
        if([[[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:1] valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
            cell.topLabel2.hidden=NO;
        }
        cell.button2.tag = 3*indexPath.section+1;
       [cell.button2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.shopLabel2.hidden = NO;
         [cell.button2 setBackgroundImageWithURL:[NSURL URLWithString:[[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:1] valueForKey:@"shop_logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
      
        
    }
    if ([[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] count] >2){
        cell.catLabel3.text = [[[[_catArray objectAtIndex:indexPath.section]valueForKey:@"shop_list"] objectAtIndex:2] valueForKey:@"shop_name"];
          cell.shopLabel3.hidden = NO;
        cell.shopLabel3.text =[[[[_catArray objectAtIndex:indexPath.section]valueForKey:@"shop_list"] objectAtIndex:2] valueForKey:@"shop_category"];
        cell.button3.tag = 3*indexPath.section+2;
       
        [cell.button3 setBackgroundImageWithURL:[NSURL URLWithString:[[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:2] valueForKey:@"shop_logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon.png"]];
       
        [cell.button3 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if([[[[[_catArray objectAtIndex:indexPath.section] valueForKey:@"shop_list"] objectAtIndex:2] valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
            cell.topLabel3.hidden=NO;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *CellIdentifier = @"Cell";
        
        ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell  = [[[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:nil options:nil]  objectAtIndex:0];
            
        }
        [self createCellForIndex:indexPath cell:cell];
        return cell;
 
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return kTableCellHeight;
}

#pragma mark - Table view delegate

-(void)viewAll:(id)sender{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    //  [detailViewController release];
    [self performSelector:@selector(showAllShop:) withObject:sender afterDelay:0.3];
}

-(void)tapAction:(id)sender{

    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    //  [detailViewController release];
    [self performSelector:@selector(showShopProducts:) withObject:sender afterDelay:0.3];
}

- (void)showAllShop:(id)sender
{
    ShopViewAllViewController *detailViewController = [[ShopViewAllViewController alloc] init];
    detailViewController.catAllArray = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getFullListOfShopsFor:[[_catArray objectAtIndex:[sender tag] ]valueForKey:@"category_id"] andPage:@"1"]];
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)showShopProducts:(id)sender
{
    ShopDetailListingViewController *detailViewController = [[ShopDetailListingViewController alloc] init];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    detailViewController.productArray = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getTopListOfItemsFor:[[[[_catArray objectAtIndex:([sender tag]/3)] valueForKey:@"shop_list"]objectAtIndex:([sender tag]%3)]valueForKey:@"shop_id"]]];
    NSLog(@"%@",_catArray);
    detailViewController.shopInfo = [[NSDictionary alloc] initWithObjectsAndKeys: [[[[_catArray objectAtIndex:([sender tag]/3)] valueForKey:@"shop_list" ] objectAtIndex:([sender tag] %3) ]valueForKey:@"shop_id"],@"shop_id", [[[[_catArray objectAtIndex:([sender tag]/3)] valueForKey:@"shop_list" ] objectAtIndex:([sender tag] %3) ]valueForKey:@"shop_name"], @"shop_name",  [[[[_catArray objectAtIndex:([sender tag]/3)] valueForKey:@"shop_list" ] objectAtIndex:([sender tag] %3) ]valueForKey:@"shop_top_seller"],@"shop_top_seller", nil];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
}

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern andOptions:optionData{
   
    NSLog(@"Filtering news list with searched text %@",str);
    self.catArray =  [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getCategoryAndTopShopFor:pattern cats:str arrangedBy:optionData]];
/*    self.selectedCategories = @"";
    self.selectedCategories = str;
    self.searchedText = @"";
    self.searchedText = pattern;
    self.pageCounter = 1;
    [self.tableData removeAllObjects];
    self.tableData = [[self loadMoreFromServer] mutableCopy];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];*/
    [[super tableView] reloadData];
    [DejalBezelActivityView removeViewAnimated:YES];
    

}

- (void)viewDidUnload {
    self.activityIndicator=nil;
    self.activityIndicatorView=nil;
    self.footerActivityIndicator=nil;
    self.tableView=nil;

    [super viewDidUnload];
}


- (void)dealloc {
    [self.tableView release];
    [[self activityIndicator] release];
    [[self activityIndicatorView] release];
    [[self footerActivityIndicator] release];
    [super dealloc];
}
@end
