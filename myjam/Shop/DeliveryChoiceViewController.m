//
//  DeliveryChoiceViewController.m
//  myjam
//
//  Created by Azad Johari on 3/5/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "DeliveryChoiceViewController.h"

@interface DeliveryChoiceViewController ()

@end

@implementation DeliveryChoiceViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCartId:(NSString*)string
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Checkout";
        self.cartId = string;
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    self.deliveryInfo = [[MJModel sharedInstance] getDeliveryInfoFor:_cartId];
    

    self.priceLabel.text = [[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:0 ] valueForKey:@"price"] stringByStrippingHTML];
     self.priceLabel.text = [[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:0 ] valueForKey:@"price"] stringByStrippingHTML];
        [super viewDidLoad];
     self.jambueFeeLabel.text = [[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:2 ] valueForKey:@"title"] stringByStrippingHTML];
    self.jambuFeeLabel.text = [[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:2 ] valueForKey:@"price"] stringByStrippingHTML];
    self.delConvenienceLabel.text = [[[[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:0 ] valueForKey:@"title"] componentsSeparatedByString:@"<br/>" ] objectAtIndex:0]stringByStrippingHTML];
    self.shipWithinLabel.text = [[[[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:0 ] valueForKey:@"title"] componentsSeparatedByString:@"<br/>" ] objectAtIndex:1]stringByStrippingHTML];
    self.infoLabel.text = [[[[_deliveryInfo valueForKey:@"delivery_option_list"] objectAtIndex:1 ] valueForKey:@"info"] stringByStrippingHTML];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_priceLabel release];
    [_nextButton release];
    
    [_jambuFeeLabel release];
    [_infoLabel release];
    [_delConvenienceLabel release];
    [_shipWithinLabel release];
    [_jambueFeeLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
 
    [self setPriceLabel:nil];
    [self setNextButton:nil];
    
    [self setJambuFeeLabel:nil];
    [self setInfoLabel:nil];
    [self setDelConvenienceLabel:nil];
    [self setShipWithinLabel:nil];
    [self setJambueFeeLabel:nil];
    [super viewDidUnload];
}
- (IBAction)nextButtonTapped:(id)sender {
    NSDictionary *status = [NSDictionary dictionaryWithDictionary:[[MJModel sharedInstance]submitDeliveryOptionFor:_cartId withOption:self.deliverChoice]];
    if ([[status valueForKey:@"status" ] isEqual:@"ok"]){
        CheckoutViewController *detailViewController = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
        detailViewController.cartList = [[NSMutableArray alloc] initWithArray:[[MJModel sharedInstance] getCartListForCartId:_cartId]];
        detailViewController.footerView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmFooterView" owner:self options:nil]objectAtIndex:0];
        detailViewController.footerType=@"1";
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
        
    }
    
}
  
@end
