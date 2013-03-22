//
//  AddressEditViewController.m
//  myjam
//
//  Created by Azad Johari on 2/3/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "AddressEditViewController.h"
#import "DeliverySelSavAddrViewController.h"

@interface AddressEditViewController ()

@end

@implementation AddressEditViewController
@synthesize addressInfo, stateSelection, countrySelection,stateButton, countryButton;

#pragma mark -
#pragma mark -Lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Checkout";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        // Custom initialization
    }
    return self;
}

- (void)setStateLabel
{
    for (int i = 0; i <[[addressInfo valueForKey:@"state_list"] count]; i++ ){
        if ([[addressInfo valueForKey:@"delivery_state_code"] isEqual:[[[addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_code"]]){
            [stateButton setTitle:[[[addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_name"] forState:UIControlStateNormal];
            self.stateSelection =[[[addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_code"];
            break;
        }
        
    }
}
- (void)setCountryLabel
{
    for (int i = 0; i <[[addressInfo valueForKey:@"country_list"] count]; i++ ){
        if ([[addressInfo valueForKey:@"delivery_country_code"] isEqual:[[[addressInfo valueForKey:@"country_list"] objectAtIndex:i] valueForKey:@"country_code"]]){
            [countryButton setTitle:[[[addressInfo valueForKey:@"country_list"] objectAtIndex:i] valueForKey:@"country_name"] forState:UIControlStateNormal];
            self.countrySelection =[[[addressInfo valueForKey:@"country_list"] objectAtIndex:i] valueForKey:@"country_code"];
            return;
        }
        
    }
}
- (void)viewDidLoad
{
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.frame = self.view.frame;
    [self.view addSubview:self.scrollView];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        [self.view setBounds:CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    
    // Toolbar for pickerView
    pickerToolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 180-40, 320, 40)];
    [pickerToolbar setBackgroundColor:[UIColor blackColor]];
    [pickerToolbar setAlpha:0.9];
//    pickerToolbar.barStyle = UIBarStyleBlack;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 12.0f;
//    [button.layer setBorderWidth:2];
//    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    button.backgroundColor = [UIColor colorWithHex:@"#0066FF"];
    [button setTintColor:[UIColor clearColor]];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self
               action:@selector(aPickerDoneClicked:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame = CGRectMake(320-80-10, 5, 80, 30);
    [pickerToolbar addSubview:button];
//    [button release];
    
//    UIBarButtonItem *aDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    
//    aDoneButton
    
//    UIBarButtonItem *aSpacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
//    [pickerToolbar setItems:[NSArray arrayWithObjects:aSpacer, aDoneButton, nil]];
//    [aDoneButton release];
//    [aSpacer release];
    pickerToolbar.hidden = YES;
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 180, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.tag = 0;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.hidden = YES;
    //    myPickerView.inputAccessoryView = pickerToolbar;
    
    [self.view addSubview:pickerToolbar];
    [self.view addSubview:myPickerView];
    [myPickerView release];
    [pickerToolbar release];
//
    myPickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 180, 320, 200)];
    myPickerView2.delegate = self;
    myPickerView2.tag = 1;
    myPickerView2.showsSelectionIndicator = YES;
    myPickerView2.hidden = YES;
    //    myPickerView.inputAccessoryView = pickerToolbar;
    
    [self.view addSubview:myPickerView2];
    [myPickerView2 release];
    
    
    //    self.cityLabel.text = [addressInfo valueForKey:@"delivery_city"];
    //    self.addressLabel.text =[addressInfo valueForKey:@"delivery_address"] ;
    //    self.postcodeLabel.text = [addressInfo valueForKey:@"delivery_postcode"];
//    if (![[addressInfo valueForKey:@"delivery_state_code"] isEqualToString:@""]){
//        [self setStateLabel];
//          }
//    else{
//        self.stateSelection = @"KUL";
//        [self.stateButton setTitle:@"Kuala Lumpur" forState:UIControlStateNormal];
//
//    }
//    if (![[addressInfo valueForKey:@"delivery_country_code"] isEqualToString:@""]){
//        [self setCountryLabel];
//
//    }
//    else{
//        self.countrySelection  = @"MY";
//        [self.countryButton setTitle:@"Malaysia" forState:UIControlStateNormal];
//    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    //*** REPLACING SELECT SAVED ADDRESSESS WITH PROGRAMMATICALLY ONE ***//
    
    [self counterOfAddress];
    
    UILabel *addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.scrollView.bounds.size.width, 20)];
    addrLabel.font = [UIFont boldSystemFontOfSize:15];
    addrLabel.textAlignment = NSTextAlignmentCenter;
    addrLabel.textColor = [UIColor colorWithHex:@"#E01B46"];
    addrLabel.backgroundColor = [UIColor clearColor];
    addrLabel.text = [NSString stringWithFormat:@"Select Saved Addresses(%d)",self.count];
    addrLabel.userInteractionEnabled = YES;
    UIGestureRecognizer *addrLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addrLabelTapSelector)];
    
    [addrLabel addGestureRecognizer:addrLabelTap];
    
    [self.scrollView addSubview:addrLabel];
    [addrLabel release];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)addrLabelTapSelector
{
    //*** TO HOOK UP WITH ADDRLABEL ***//
    
    if (self.count != 0)
    {
        [self.scrollView endEditing:YES];
        
        DeliverySelSavAddrViewController *detailViewController = [[DeliverySelSavAddrViewController alloc] init];
        detailViewController.getCartID =_cartId;
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Saved Address" message:@"You haven't save any address yet. You may save your address in Settings - Update Jambulite Profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

-(void)counterOfAddress
{
    NSLog(@"Counting");
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *paramString = [NSString stringWithFormat:@"{\"flag\":\"%@\"}",@"DEFAULT"];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:paramString];
    
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    NSDictionary *content;
    self.count = 0;
    NSLog(@"resultsdict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            if (! [[resultsDictionary objectForKey:@"address"] isKindOfClass:[NSString class]])
            {
                content = [resultsDictionary objectForKey:@"address"];
                
                for (id row in content)
                {
                    self.count++;
                }
            }
        }
    }
}



-(void)dismissKeyboard
{
    UITextView *activeTextView = nil;
    if ([_addressLabel isFirstResponder]) activeTextView = _addressLabel;
    else if ([_postcodeLabel isFirstResponder]) activeTextView = _postcodeLabel;
    else if ([_cityLabel isFirstResponder]) activeTextView = _cityLabel;
    if (activeTextView) [activeTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_addressLabel release];
    [_cityLabel release];
    [_postcodeLabel release];
    [stateButton release];
    [countryButton release];
    [addressInfo release];
    [_SelectAddressButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setAddressLabel:nil];
    [self setCityLabel:nil];
    [self setPostcodeLabel:nil];
    [self setStateButton:nil];
    [self setCountryButton:nil];
    [self setSelectAddressButton:nil];
    [super viewDidUnload];
    
}

#pragma mark -
#pragma mark -IBaction for 3 buttons

- (IBAction)stateTapped:(id)sender {
    [myPickerView setHidden:NO];
    [pickerToolbar setHidden:NO];
}

- (IBAction)countryTapped:(id)sender {
    [myPickerView2 setHidden:NO];
    [pickerToolbar setHidden:NO];
}

- (void)aPickerDoneClicked:(id)sender
{
    if (myPickerView.hidden == NO) {
        if ([self.stateButton.titleLabel.text isEqualToString:@"Select a state from the list                                                                                                  "]) {
            [self.stateButton setTitle:[[[addressInfo valueForKey:@"state_list"] objectAtIndex:0] valueForKey:@"state_name"]  forState:UIControlStateNormal];
            stateSelection =[[[addressInfo valueForKey:@"state_list"] objectAtIndex:0] valueForKey:@"state_code"];
        }
        
        [myPickerView setHidden:YES];
    }else{
        [myPickerView2 setHidden:YES];
        if ([self.stateButton.titleLabel.text isEqualToString:@"Select a Country from the list                                                                                                  "]) {
            [self.countryButton setTitle:[[[addressInfo valueForKey:@"country_list"] objectAtIndex:0] valueForKey:@"country_name"] forState:UIControlStateNormal];
            countrySelection = [[[addressInfo valueForKey:@"country_list"] objectAtIndex:0] valueForKey:@"country_code"];
        }

    }
    [pickerToolbar setHidden:YES];
    
    NSLog(@"test");
}

- (IBAction)selectAddress:(id)sender {
    DeliveryOptionViewController *detailViewController = [[DeliveryOptionViewController alloc] init];
    detailViewController.cartId =_cartId;
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
}
- (void)createAlertViewFor:(NSString*)labelName {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@ is required",labelName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (IBAction)nextTapped:(id)sender {
    
    if ([self.addressLabel.text isEqualToString:@""]){
        [self createAlertViewFor:@"Address"];
        
        
    } else if ([self.postcodeLabel.text isEqualToString:@""]){
        [self createAlertViewFor:@"Postcode"];
        
    } else{
        NSDictionary *status = [[MJModel sharedInstance] submitAddressForCart:_cartId forAddress:self.addressLabel.text  inCity:self.cityLabel.text withPostcode:_postcodeLabel.text inState:stateSelection inCountry:countrySelection];
        
        if ([[status valueForKey:@"status" ] isEqual:@"ok"]){
            NSDictionary *dictTemp = [[MJModel sharedInstance] getDeliveryInfoFor:_cartId];
            
            if ([[dictTemp valueForKey:@"delivery_option_list"] count] ==1){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [alertView release];
                
            }else{
                DeliveryChoiceViewController *detailViewController = [[DeliveryChoiceViewController alloc] initWithNibName:@"DeliveryChoiceViewController" bundle:nil andCartId:_cartId];
                
                
                
                AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                
                [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
                [detailViewController release];
            }
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
        }
        
        //[self.navigationController pushViewController:detailViewController animated:YES];
        
    }
    
    
}

#pragma mark -
#pragma mark -UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 0){
        [self.stateButton setTitle:[[[addressInfo valueForKey:@"state_list"] objectAtIndex:row] valueForKey:@"state_name"]  forState:UIControlStateNormal];
        stateSelection =[[[addressInfo valueForKey:@"state_list"] objectAtIndex:row] valueForKey:@"state_code"];
        
        
    }
    else if (pickerView.tag == 1){
        [self.countryButton setTitle:[[[addressInfo valueForKey:@"country_list"] objectAtIndex:row] valueForKey:@"country_name"] forState:UIControlStateNormal];
        countrySelection = [[[addressInfo valueForKey:@"country_list"] objectAtIndex:row] valueForKey:@"country_code"];
        
        
    }
    
    //    pickerView.hidden = TRUE;
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == 0){
        return [[addressInfo valueForKey:@"state_list"] count];
    }
    else if (pickerView.tag == 1){
        return [[addressInfo valueForKey:@"country_list"] count];
    }
    
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    if (pickerView.tag == 0){
        title = [[[addressInfo valueForKey:@"state_list"] objectAtIndex:row] valueForKey:@"state_name"];
        
    }
    else if (pickerView.tag == 1)
    {
        title = [[[addressInfo valueForKey:@"country_list"] objectAtIndex:row] valueForKey:@"country_name"];
    }
    
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}
#pragma mark-
#pragma mark Textview delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (myPickerView.hidden == NO) {
        [myPickerView setHidden:YES];
    }else if (myPickerView2.hidden == NO){
        [myPickerView2 setHidden:YES];
    }
    
    if (pickerToolbar.hidden == NO) {
        [pickerToolbar setHidden:YES];
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}


@end
