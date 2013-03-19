//
//  ProductRatingListViewController.m
//  myjam
//
//  Created by Azad Johari on 2/1/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ProductRatingListViewController.h"
#define kTableCellHeight 100
@interface ProductRatingListViewController ()

@end

@implementation ProductRatingListViewController
@synthesize tableView,shopName;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentWritten:)
                                                 name:@"CommentWritten"
                                               object:nil];
    self.productLabel.text = _productName;
    self.shopNameLabel.text = shopName;
    [self setNavBarTitle:@"Review"];
    
    MarqueeLabel *shopeName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(192, 59, 115, 21) rate:20.0f andFadeLength:10.0f];
    shopeName.marqueeType = MLContinuous;
    shopeName.animationCurve = UIViewAnimationOptionCurveLinear;
    shopeName.numberOfLines = 1;
    shopeName.opaque = NO;
    shopeName.enabled = YES;
    shopeName.textAlignment = NSTextAlignmentLeft;
    shopeName.textColor = [UIColor blackColor];
    shopeName.backgroundColor = [UIColor whiteColor];
    shopeName.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    shopeName.text = self.productLabel.text;
    [self.view addSubview:shopeName];
    [shopeName release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_reviewList count] == 0){
        return 1;
    }
    else{
    // Return the number of rows in the section.
    return [_reviewList count];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"Cell";
    
    if ([_reviewList count] >0){
        CommentViewCell *cell = (CommentViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        // Configure the cell...
        
        
        // Configure the cell...
        [self createCellForIndex:indexPath cell:cell];
        return cell;
  
    }
    else{
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }

        cell.textLabel.text = @"No records.";
    
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
}
- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(CommentViewCell *)cell
{cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [[_reviewList objectAtIndex:indexPath.row] valueForKey:@"username"];
    cell.dateLabel.text = [[_reviewList objectAtIndex:indexPath.row] valueForKey:@"datetime"];
    [cell.userImage setImageWithURL:[[_reviewList objectAtIndex:indexPath.row] valueForKey:@"image"]];
    cell.reviewLabel.text = [[_reviewList objectAtIndex:indexPath.row] valueForKey:@"comment"];
    if ([[[_reviewList objectAtIndex:indexPath.row] valueForKey:@"rating"]  isEqual:@"0"]){
        cell.rateView.hidden = TRUE;
    }
    else{
        cell.rateView.rating = [[[_reviewList objectAtIndex:indexPath.row] valueForKey:@"rating"] intValue];
        cell.rateView.editable = FALSE;
        cell.rateView.selectedImage = [UIImage imageNamed:@"star.png"];
        cell.rateView.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
    cell.rateView.maxRating = 5;}
    //to add valueforkey rating
    //toadd valueforking image
    //toadd modify datetime to format
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    [_productName release];
    [tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_shopNameLabel release];
    [shopName release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProductName:nil];
    [self setShopNameLabel:nil];
    [super viewDidUnload];
}
- (IBAction)reviewAction:(id)sender {
    WriteReviewViewController *detailViewController = [[WriteReviewViewController alloc] init];
    detailViewController.productInfo =[[MJModel sharedInstance]getReviewInfoFor:self.productId];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    // [detailViewController release];
}

- (IBAction)viewShop:(id)sender {
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    for (int i=0 ; i< [mydelegate.shopNavController.viewControllers count]; i++){
      

        if( [[[mydelegate.shopNavController.viewControllers objectAtIndex:i] class] isEqual:[ShopDetailListingViewController class]])
        {
            NSLog(@"ok");
   
            [mydelegate.shopNavController popToViewController:[mydelegate.shopNavController.viewControllers objectAtIndex:i] animated:YES];
            break;

    }
        
    
    }
  
}
-(void)commentWritten:(NSNotification*)notification{
    self.reviewList = [[MJModel sharedInstance] getProductReviewFor:self.productId inPage:@"1"];
    [tableView reloadData];
}
@end
