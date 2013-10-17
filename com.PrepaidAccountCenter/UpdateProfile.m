//
//  UpdateProfile.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "UpdateProfile.h"
#import "UIColor+Hex.h"
#import "CardInfo.h"
#import "SingletonGeneric.h"
#import "AppHelper.h"


@interface UpdateProfile ()
@end

CardInfo *cInfo;
UIPickerView *myPickerView;
NSMutableArray *PickerArray;
UIButton *doneButton ;
NSString* PickerViewType;
NSString* PickerSlectedValue;

@implementation UpdateProfile

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Update Profile";
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    cInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
    
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: ", cInfo.cardNumber ];
    [_lblHeaderCard setText:cardNumbertxt];
    
    _uiHeader.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _uiHeader.layer.cornerRadius = 8; // if you like rounded corners
    _uiHeader.layer.shadowOffset = CGSizeMake(-15, 20);
    _uiHeader.layer.shadowRadius = 5;
    _uiHeader.layer.shadowOpacity = 0.5;
    
    [SVProgressHUD showWithStatus:@"Retriving Profile.\n Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    [networkRequest makeWebCall:[NSString stringWithFormat:GET_PROFILE_SERVICE_URL,cInfo.cardProxy, cInfo.WcsClientID] httpMethod:RTHTTPMethodGET];
    [_btnUpdateProfile useBlackStyle];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"UpdateProfileLogout" sender:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //responder = textField;
    BOOL ShowPicker = NO;
    if ([textField isEqual:_txtCountry]) {
        PickerArray=[AppHelper GetCountryList];
        PickerViewType = @"COUNTRY";
        ShowPicker = YES;
        
    }
    else if ([textField isEqual:_txtState])
    {
        PickerArray=[AppHelper GetStateList:_txtCountry.text];
        if (PickerArray != nil)
        {
            PickerViewType = @"STATE";
            ShowPicker = YES;
        }
        else
        {
            textField.inputView = UIKeyboardAppearanceDefault;
        }
        
    }
    
    if (ShowPicker)
    {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
        myPickerView.delegate = self;
        myPickerView.dataSource = self;
        myPickerView.showsSelectionIndicator = YES;
        [self.view addSubview:myPickerView];
        UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
        
        mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [mypickerToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked)];
        [barItems addObject:doneBtn];
        [barItems addObject:cancelBtn];
        [mypickerToolbar setItems:barItems animated:YES];
        textField.inputAccessoryView = mypickerToolbar;
        [myPickerView reloadAllComponents];
        textField.inputView = myPickerView;
        
    }
    return YES;
}

- (IBAction)hideKeyBoard:(id)sender
{
    [_txtFirstName resignFirstResponder];
    [_txtLastName resignFirstResponder];
    [_txtAddress1 resignFirstResponder];
    [_txtAddress2 resignFirstResponder];
    [_txtCity resignFirstResponder];
    [_txtState resignFirstResponder];
    [_txtZip resignFirstResponder];
    // [_txtCountry resignFirstResponder];
    [_txtPhone resignFirstResponder];
    
}

-(void) serviceCallCompletedWithError:(NSError*) error
{
    
    [SVProgressHUD dismiss];
    NSString* str = [NSString stringWithFormat:@"An error occured while retriving PIN.\n Please contact customer support for more details."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    
    if (responseArray != nil) {
        
        
        for (NSDictionary* dict in responseArray){
            
            if([dict count] == 1)
            {
                NSString* str = [dict objectForKey:@"Message"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                
                [_txtFirstName setText:[dict objectForKey:@"FirstName"]];
                [_txtLastName setText:[dict objectForKey:@"LastName"]];
                [_txtAddress1 setText:[dict objectForKey:@"Address1"]];
                [_txtAddress2 setText:[dict objectForKey:@"Address2"]];
                [_txtCity setText:[dict objectForKey:@"City"]];
                [_txtState setText:[dict objectForKey:@"State"]];
                [_txtZip setText:[dict objectForKey:@"Zip"]];
                [_txtCountry setText:[dict objectForKey:@"Country"]];
                [_txtPhone setText:[dict objectForKey:@"Phone"]];
                
            }
        }
        
    }
    
    else
    {
        NSString* str = [NSString stringWithFormat:@"An error occured while retriving PIN.\n Please contact customer support for more details."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
}


- (void)networkNotReachable{}
- (IBAction)btnUpdateProfile_Click:(id)sender {
    NSString* Error=  @"";
    if(_txtFirstName.text.length == 0 )
    {
        Error =[Error stringByAppendingString: @"\nPlease enter the First Name"];
    }
    if (_txtLastName.text.length == 0)
    {
        Error =[Error stringByAppendingString: @"\nPlease enter the Last Name"];}
    if (_txtAddress1.text.length == 0)
    {
        Error =[Error stringByAppendingString: @"\nPlease enter Address 1"];}
    if (_txtCity.text.length == 0)
    {
        Error =[Error stringByAppendingString: @"\nPlease enter City "];}
    if (_txtCountry.text.length == 0)
    {
        Error =[Error stringByAppendingString: @"\nPlease select Country"];}
    if (_txtState.text.length == 0)
    {
        Error =[Error stringByAppendingString: @"\nPlease select state"];}
    if (_txtZip.text.length == 0)
    {
        Error =[Error stringByAppendingString: @"\nPlease enter Zip"];}
    
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return PickerArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    PickerSlectedValue =   [NSString stringWithFormat:@"%@",[PickerArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
    
    
}

- (IBAction)pickerDoneClicked
{
    
    if ([PickerViewType isEqualToString:@"COUNTRY"])
    {
        _txtCountry.text = PickerSlectedValue;
        [_txtCountry resignFirstResponder];
    }
    else
    {
        _txtState.text = PickerSlectedValue;
        [_txtState resignFirstResponder];
    }
    
    [myPickerView removeFromSuperview];
    
}

-(IBAction)pickerCancelClicked
{
    [myPickerView removeFromSuperview];
    if ([PickerViewType isEqualToString:@"COUNTRY"])
    {
        
        [_txtCountry resignFirstResponder];
    }
    else
    {
        [_txtState resignFirstResponder];
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [PickerArray objectAtIndex:row];
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
    componentWidth = 135.0;
    return componentWidth;}
@end
