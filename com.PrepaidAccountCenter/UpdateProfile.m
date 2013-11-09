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
#import "CountryStateData.h"
#import "Country.h"
#import "State.h"

#define UPDATE_PROFILE_POPUP_CONFIRMATION 1

@interface UpdateProfile ()
@end

CardInfo *cInfo;
UIPickerView *myPickerView;
NSMutableArray *PickerArray;
UIButton *doneButton ;
NSString* PickerViewType;
Country* SelectedCountry;
State* SelectedState;
NSString* CurrentCountryListVersion;
NSString* CurrentStateListVersion;
CGPoint Form_initialPoint;
NSDictionary* dictProfileData;

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
    PickerArray = nil;
    PickerViewType = nil;
    SelectedCountry = nil;
    SelectedState = nil;;
    CurrentCountryListVersion= nil;
    CurrentStateListVersion = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    Form_initialPoint = _vwForm.center;
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Update Profile";
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    _uiHeader.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _uiHeader.layer.cornerRadius = 8; // if you like rounded corners
    _uiHeader.layer.shadowOffset = CGSizeMake(-15, 20);
    _uiHeader.layer.shadowRadius = 5;
    _uiHeader.layer.shadowOpacity = 0.5;
    
    [_btnUpdateProfile useBlackStyle];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    dictProfileData = nil;
    cInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: ", cInfo.cardNumber ];
    [_lblHeaderCard setText:cardNumbertxt];
    [SVProgressHUD showWithStatus:@"Retriving Profile.\n Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    networkRequest.currentCallType = [NSMutableString stringWithString:@"Get_Profile_data"];
    [networkRequest makeWebCall:[NSString stringWithFormat:GET_PROFILE_SERVICE_URL,cInfo.cardProxy, cInfo.WcsClientID] httpMethod:RTHTTPMethodGET];
    
    
    
}

-(void) UpdateCountries
{
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    networkRequest.currentCallType = [NSMutableString stringWithString:@"update_countries"];
    [networkRequest makeWebCall:COUNTRY_LIST_SERVICE httpMethod:RTHTTPMethodGET];
}

-(void) UpdateStates
{
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    networkRequest.currentCallType = [NSMutableString stringWithString:@"update_states"];
    [networkRequest makeWebCall:STATE_LIST_SERVICE httpMethod:RTHTTPMethodGET];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"UpdateProfileLogout" sender:nil];
}



-(void)keyboardDidHide:(NSNotification *)notification
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _vwForm.center = Form_initialPoint;
    [UIView commitAnimations];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //responder = textField;
    BOOL ShowPicker = NO;
    if ([textField isEqual:_txtCountry]) {
        [self SetSelectedCountry];
        
        CountryStateData* cdata = [[CountryStateData alloc] init];
        
        
        PickerArray=[cdata getAllRecords:@"Country"]; ;
        PickerViewType = @"COUNTRY";
        ShowPicker = YES;
        
    }
    else if ([textField isEqual:_txtState])
    {
        CountryStateData* cdata = [[CountryStateData alloc] init];
        
        [self SetSelectedCountry];
        
        NSPredicate *bPredicate =[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"countrycode ==[c] '%@%@",SelectedCountry.countrycode ,@"'"]];
        
        PickerArray=[cdata getAllRecords:@"State"];
        [PickerArray filterUsingPredicate:bPredicate];
        if (PickerArray != nil && [PickerArray count] > 0 )
        {
            [self SetSelectedState];
            PickerViewType = @"STATE";
            ShowPicker = YES;
        }
        else
        {
            textField.inputView = UIKeyboardAppearanceDefault;
            ShowPicker = NO;
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
        if ([PickerViewType isEqualToString: @"COUNTRY"])
        {
            [myPickerView selectRow:[PickerArray indexOfObject:SelectedCountry] inComponent:0 animated:NO];
        }
        else if ([PickerViewType isEqualToString: @"STATE"])
        {
            [myPickerView selectRow:[PickerArray indexOfObject:SelectedState] inComponent:0 animated:NO];
        }
    }
    else{
        textField.inputAccessoryView = nil;
        
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSInteger PoistionFromBottom = screenRect.size.height - (textField.frame.origin.y + textField.frame.size.height + _vwForm.frame.origin.y + self.navigationController.navigationBar.frame.size.height);
    if (PoistionFromBottom < 300) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        _vwForm.center = CGPointMake(_vwForm.center.x,
                                     _vwForm.center.y  - (320 - PoistionFromBottom));
        [UIView commitAnimations];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
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
    [_txtCountry resignFirstResponder];
    [_txtPhone resignFirstResponder];
    
}

-(void) serviceCallCompletedWithError:(NSError*) error
{
    
    [SVProgressHUD dismiss];
    NSString* str = [NSString stringWithFormat:@"An error occured while making the API call.\n Please contact customer support for more details."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    if ([currentCallType isEqualToString:@"Get_Profile_data"])
    {
        if (responseArray != nil) {
            
            
            for (NSDictionary* dict in responseArray){
                
                if([dict count] == 1)
                {
                    NSString* str = [dict objectForKey:@"Message"];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    dictProfileData = dict;
                    [_txtFirstName setText:[dict objectForKey:@"FirstName"]];
                    [_txtLastName setText:[dict objectForKey:@"LastName"]];
                    [_txtAddress1 setText:[dict objectForKey:@"Address1"]];
                    [_txtAddress2 setText:[dict objectForKey:@"Address2"]];
                    [_txtCity setText:[dict objectForKey:@"City"]];
                    [_txtState setText:[dict objectForKey:@"State"]];
                    [_txtZip setText:[dict objectForKey:@"Zip"]];
                    [_txtCountry setText:[dict objectForKey:@"Country"]];
                    [_txtPhone setText:[dict objectForKey:@"Phone"]];
                    
                    CurrentCountryListVersion = [dict objectForKey:@"CountryListVersion"];
                    CurrentStateListVersion = [dict objectForKey:@"StateListVersion"];
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    NSString* StoredCountryListVersion  = [prefs stringForKey:@"CountryListVersion"] ;
                    NSString* StoredStateListVersion  = [prefs stringForKey:@"StateListVersion"] ;
                    
                    if(StoredCountryListVersion == nil || ![StoredCountryListVersion isEqualToString: CurrentCountryListVersion])
                    {
                        //[self performSelectorInBackground:@selector(UpdateCountries) withObject:nil];
                        [self UpdateCountries];
                        [SVProgressHUD showWithStatus:@"Retriving Profile.\n Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
                        
                    }
                    if(StoredStateListVersion == nil || ![StoredStateListVersion isEqualToString: CurrentStateListVersion])
                        
                    {
                        [self UpdateStates];
                        [SVProgressHUD showWithStatus:@"Retriving Profile.\n Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
                        
                    }
                    
                }
            }
            
        }
        
        else
        {
            NSString* str = [NSString stringWithFormat:@"An error occured while retriving Profile.\n Please contact customer support for more details."];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
    
    else if ([currentCallType isEqualToString:@"Update_card_Profile"])
    {
        if (responseArray != nil) {
            for (NSDictionary* dict in responseArray){
                if([dict objectForKey:@"Message"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [dict objectForKey:@"Message"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"There is an error occured while updating the card profile.\n Please try again later." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"There is an error occured while updating the card profile.\n Please try again later." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
    }
    else if ([currentCallType isEqualToString:@"update_states"])
    {
        CountryStateData* cdata = [[CountryStateData alloc]init];
        [cdata InsertStates:responseArray ForStateListVersion:CurrentStateListVersion];
    }
    
    else if ([currentCallType isEqualToString:@"update_countries"])
    {
        CountryStateData* cdata = [[CountryStateData alloc]init];
        [cdata InsertCountries:responseArray ForCountryListVersion:CurrentCountryListVersion];
    }
    
    
}

-(Country*) SetSelectedCountry
{
    if(SelectedCountry == nil)
    {
        CountryStateData* cdata = [[CountryStateData alloc] init];
        NSMutableArray* tempCountries = [cdata getAllRecords:@"Country"];
        [tempCountries filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"countrycode== [c]'%@' OR country==[c]'%@' OR a3==[c]'%@' or a2 ==[c] '%@'", _txtCountry.text, _txtCountry.text,_txtCountry.text,_txtCountry.text]]];
        if (tempCountries != nil && [tempCountries count] >0 )
        {
            SelectedCountry = ((Country*)[tempCountries objectAtIndex:0]);
        }
    }
    
    return SelectedCountry;
    
}
-(State*) SetSelectedState
{
    if(SelectedState == nil && SelectedCountry != nil)
    {
        CountryStateData* cdata = [[CountryStateData alloc] init];
        NSString* stateCode;
        NSString* stateName;
        if (![_txtState.text rangeOfString:@"-"].location == NSNotFound)
        {
            stateCode = [[[_txtState.text componentsSeparatedByString:@"-"] objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            stateName = [[[_txtState.text componentsSeparatedByString:@"-"] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else
        {
            stateCode = _txtState.text;
            stateName = _txtState.text;
        }
        NSMutableArray* tempStates = [cdata getAllRecords:@"State"];
        [tempStates filterUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"countrycode ='%@' AND (statecode==[c]'%@' OR statename==[c]'%@')",SelectedCountry.countrycode, stateCode, stateName]]];
        if (tempStates != nil && [tempStates count] >0 )
        {
            SelectedState = ((State*)[tempStates objectAtIndex:0]);
        }
    }
    
    return SelectedState;
    
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
    [self SetSelectedCountry];
    if(SelectedCountry != nil && SelectedCountry.zip_validation != nil && SelectedCountry.zip_validation.length > 0)
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:SelectedCountry.zip_validation options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:_txtZip.text options:0 range:NSMakeRange(0, [_txtZip.text length])];
        if(numberOfMatches ==0)
        {
            Error =[Error stringByAppendingString: @"\nInvalid Zip"];
        }
        
    }
    if(SelectedCountry != nil && SelectedCountry.phone_validation != nil && SelectedCountry.phone_validation.length > 0 && _txtPhone.text.length > 0)
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:SelectedCountry.phone_validation options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:_txtPhone.text options:0 range:NSMakeRange(0, [_txtPhone.text length])];
        if(numberOfMatches ==0)
        {
            Error =[Error stringByAppendingString: @"\nInvalid Phone"];
        }
        
    }
    
    if(Error.length != 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [NSString stringWithFormat:@"%@",Error] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [NSString stringWithFormat:@"\nAre you sure, you want to update the card profile ?"] delegate: self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
        alert.tag = UPDATE_PROFILE_POPUP_CONFIRMATION;
        [alert show];
    }
    
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == UPDATE_PROFILE_POPUP_CONFIRMATION &&   buttonIndex == 0){
        
        RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
        networkRequest.currentCallType = [NSMutableString stringWithString:@"Update_card_Profile"];
        [networkRequest makeWebCall:[NSString stringWithFormat:UPDATE_CARD_PROFILE_SERVICE, [dictProfileData objectForKey:@"PersonID"], _txtFirstName.text, _txtLastName.text,_txtAddress1.text,_txtAddress2.text,_txtCity.text,SelectedCountry.countrycode,_txtState.text,_txtZip.text,_txtPhone.text,[dictProfileData objectForKey:@"Email"]] httpMethod:RTHTTPMethodGET];
        [SVProgressHUD  showWithStatus:@"Updating Profile.\nPlease wait ..." maskType:SVProgressHUDMaskTypeGradient];
    }else if (buttonIndex == 1){
        //reset clicked
    }
}



// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return PickerArray.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}



- (IBAction)pickerDoneClicked
{
    
    if ([PickerViewType isEqualToString:@"COUNTRY"])
    {
        SelectedCountry = ((Country*)[PickerArray objectAtIndex:[myPickerView selectedRowInComponent:0]]);
        _txtCountry.text = SelectedCountry.country;
        [_txtCountry resignFirstResponder];
    }
    else
    {
        SelectedState = ((State*)[PickerArray objectAtIndex:[myPickerView selectedRowInComponent:0]]);
        _txtState.text =[NSString stringWithFormat:@"%@ - %@",SelectedState.statecode, SelectedState.statename];
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
    NSString* returnVal;
    if ([PickerViewType isEqualToString: @"COUNTRY"])
    {
        Country* ctr = [PickerArray objectAtIndex:row];
        returnVal = ctr.country;
        
    }
    else{
        State* state = [PickerArray objectAtIndex:row];
        returnVal = [NSString stringWithFormat:@"%@ - %@",state.statecode, state.statename];
    }
    return returnVal;
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return self.view.frame.size.width;
}
@end
