//
//  ManageUserCredentials.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/25/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "ManageUserCredentials.h"
#define POPUP_TAG_USERCREDENTIAL_SUCCESS 1

@interface ManageUserCredentials ()
@property (weak, atomic) NSString* ControlType;

@end

@implementation ManageUserCredentials

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
    
	// Do any additional setup after loading the view.
    [_btnCreate useBlackStyle];
    [_btnCancel useBlackStyle];
    _vwMain.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _vwMain.layer.cornerRadius = 8; // if you like rounded corners
    _vwMain.layer.shadowOffset = CGSizeMake(-15, 20);
    _vwMain.layer.shadowRadius = 5;
    _vwMain.layer.shadowOpacity = 0.5;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    
    //NSLOG (@"DEFInevalue%@", LOGGEDIN_OPTION_USERNAME);
    
    NSString* LoginByOption = [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_SELECTED_LOGIN_OPTION];
    if ([LoginByOption isEqualToString:LOGGEDIN_OPTION_CARD])
    {
        _ControlType = @"create";
    }
    [self setUpPage];
    
}

-(void) setUpPage
{
    
    if ([_ControlType isEqualToString:@"create"])
    {
        [_lblOldPassword setHidden:YES];
        [_txtOldPAssword setHidden:YES];
        _constlblPassword.constant = 70;
        _vwHeightConstraint.constant = 250;
        [_btnCreate setTitle:@"Create" forState:UIControlStateNormal];
    }
    else{
        [_lblOldPassword setHidden:NO];
        [_txtOldPAssword setHidden:NO];
        _constlblPassword.constant = 140;
        _vwHeightConstraint.constant = 330;
        [_btnCreate setTitle:@"Update" forState:UIControlStateNormal];
    }
    [_lblErrorMessage setText:@""];
    
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    
    if (![_ControlType isEqualToString:@"create"] && [[AppHelper DeviceType]  isEqualToString:@"iphone"] )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        _vwMain.center = CGPointMake(_vwMain.center.x,
                                     _vwMain.center.y  - 50);
        [UIView commitAnimations];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    if (![_ControlType isEqualToString:@"create"] && [[AppHelper DeviceType]  isEqualToString:@"iphone"] )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        _vwMain.center = CGPointMake(_vwMain.center.x,
                                     _vwMain.center.y  + 50);
        [UIView commitAnimations];
    }
}

- (IBAction)hideKeyBoard:(id)sender
{
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPAssword resignFirstResponder];
    [_txtOldPAssword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtConfirmPAssword resignFirstResponder];
    [_txtOldPAssword resignFirstResponder];
    return true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Home_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnCreate_Click:(id)sender {
    if ([_ControlType isEqualToString:@"create"] )
    {
        if (_txtUsername.text.length == 0 || _txtPassword.text.length ==0 || _txtConfirmPAssword.text.length == 0)
        {
            [_lblErrorMessage setText:@"* All Fields are required"];
        }
        else if (![_txtPassword.text isEqualToString:_txtConfirmPAssword.text ])
        {
            [_lblErrorMessage setText:@"* Password and confirm Password should match."];
        }
        else if(_txtPassword.text.length < 5 )
        {[_lblErrorMessage setText:@"* Password should be minimum 5 characters"];}
        else{
            RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
            networkRequest.currentCallType = [NSMutableString stringWithString:@"CreateCredentialCall"];
            [networkRequest makeWebCall:[NSString stringWithFormat:CREATE_CREDENTIAL_SERVICE_URL, _txtUsername.text, _txtPassword.text] httpMethod:RTHTTPMethodGET];
            
        }
        
    }
    
}

-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    if ([currentCallType isEqualToString:@"CreateCredentialCall"]) {
        NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
        if (responseArray != nil) {
            for (NSDictionary* dict in responseArray){
                if([dict objectForKey:@"Message"])
                {
                    
                    if ([[[dict objectForKey:@"Message"] uppercaseString] isEqualToString:@"SUCCESS"])
                    {
                        NSString* SuccessMessage = @"Credentials created successfully.\n Do you want to Add card(";
                        SuccessMessage= [SuccessMessage stringByAppendingString:[[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_USERNAME]];
                        SuccessMessage =  [SuccessMessage stringByAppendingString:@") to this username ?"];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message:SuccessMessage  delegate: self cancelButtonTitle:@"YES" otherButtonTitles:@"No", nil];
                        alert.tag = POPUP_TAG_USERCREDENTIAL_SUCCESS;
                        [alert show];
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [dict objectForKey:@"Message"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"There is an error occured while creating the username.\n Please try again later." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            
            
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"There is an error occured while creating the username.\n Please try again later." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else if ([currentCallType isEqualToString:@"AddCardToUserService"])
    {
    
    }
    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Tag:%@",[NSString stringWithFormat:@"%0.0f", (float)alertView.tag]);
    if (alertView.tag == POPUP_TAG_USERCREDENTIAL_SUCCESS &&   buttonIndex == 0){
        NSString* CurrentCardNumber = [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_USERNAME];
        NSString* CurrentCardPin = [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_PASSWORD];
        RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
        networkRequest.currentCallType = [NSMutableString stringWithString:@"AddCardToUserService"];
        [networkRequest makeWebCall:[NSString stringWithFormat:ADD_CARD_TO_USER_SERVICE_URL, CurrentCardNumber, CurrentCardPin] httpMethod:RTHTTPMethodGET];
    }else if (buttonIndex == 1){
        //reset clicked
    }
}

- (void)networkNotReachable{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: INTERNET_NOT_AVAILABLE_POPUP_TITLE message: INTERNET_NOT_AVAILABLE_POPUP_TEXT delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)btnReset_Click:(id)sender {
    [_txtUsername setText:@""];
    [_txtPassword setText:@""];
    [_txtConfirmPAssword setText:@""];
    [_txtOldPAssword setText:@""];
}
@end
