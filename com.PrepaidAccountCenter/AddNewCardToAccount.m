//
//  AddNewCardToAccount.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/31/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "AddNewCardToAccount.h"
#import "UIColor+Hex.h"
#import "AppHelper.h"
#import "AppConstants.h"
#import"SingletonGeneric.h"
#import "SVProgressHUD.h"
@interface AddNewCardToAccount ()

@end

@implementation AddNewCardToAccount

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
    [_btnAddCard useBlackStyle];
    [_btnClear useBlackStyle];

    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    [_lblMessageTop setText:@""];
    
    
    _vwMain.backgroundColor = [UIColor clearColor];
       
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    _vwMain.backgroundColor = [UIColor clearColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        _navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else
    {
        _navigationBar.barStyle = UIBarStyleBlackOpaque;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)hideKeyBoard:(id)sender
{
    [_txtCardNumber resignFirstResponder];
    [_txtSecurityPin resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtCardNumber resignFirstResponder];
    [_txtSecurityPin resignFirstResponder];
    return  true;
}

- (IBAction)btnHome_Click:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnAddCard_Click:(id)sender {
    
    [_lblMessageTop setText:@""];
    if ([AppHelper isEmptyString:[_txtCardNumber text]])
    {
        [_lblMessageTop setText:@"Please Enter Card Number !!!"];
    }
    else if ([AppHelper isEmptyString:[_txtSecurityPin text]])
    {
        [_lblMessageTop setText:@"Please Enter Security Pin !!!"];
    }
    else if ([_txtCardNumber text].length != 16){
        [_lblMessageTop setText:@"Invlid Cardnumber !!!"];
        
    }
    else if ([_txtSecurityPin text].length != 3){
        
        [_lblMessageTop setText:@"Invalid Pin !!!"];
    }
    else
    {
        NSString* UserCredentialID = [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_USERCREDNTIALID];
        [SVProgressHUD showWithStatus:@"Please Wait ..."];
        RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
        networkRequest.currentCallType = [NSMutableString stringWithString:@"AddCardToUserService"];
        [networkRequest makeWebCall:[NSString stringWithFormat:ADD_CARD_TO_USER_SERVICE_URL, UserCredentialID, _txtCardNumber.text, _txtSecurityPin.text] httpMethod:RTHTTPMethodGET];
    }
    
}
- (void)networkNotReachable{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: INTERNET_NOT_AVAILABLE_POPUP_TITLE message: INTERNET_NOT_AVAILABLE_POPUP_TEXT delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [SVProgressHUD dismiss];
}

-(void)serviceCallCompletedWithError: (NSError *) error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: SERVICE_ERROR_POPUP_TITLE message: SERVICE_ERROR_POPUP_TEXT delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [SVProgressHUD dismiss];
}

-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    if ([currentCallType isEqualToString:@"AddCardToUserService"])
    {
        NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
        if (responseArray != nil) {
            for (NSDictionary* dict in responseArray){
                if([dict objectForKey:@"Message"])
                {
                    
                    if ([[[dict objectForKey:@"Message"] uppercaseString] isEqualToString:@"SUCCESS"])
                    {
                        RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
                        networkRequest.currentCallType = [NSMutableString stringWithString:@"RetrieveCardInformation"];
                        [networkRequest makeWebCall:[NSString stringWithFormat:AUTHENTICATE_SERVICE_URL, _txtCardNumber.text, _txtSecurityPin.text,@"Card"] httpMethod:RTHTTPMethodGET];
                        NSString* SuccessMessage = @"Card added successfully.";
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message:SuccessMessage  delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    else if ([currentCallType isEqualToString:@"RetrieveCardInformation"])
    {
        NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
        NSString* ErrorMessage = @"";
        
        if (responseArray != nil) {
            for (NSDictionary* dict in responseArray){
                if([dict count] == 1 && [dict objectForKey:@"Message"] )
                {
                    ErrorMessage = [dict objectForKey:@"Message"];
                }
                else{
                    CardInfo* ci = [[CardInfo alloc] initWithDictionary:dict];
                    [ [SingletonGeneric UserCardInfo] addCardInfo:ci];
                }
            }
        }
        else
        {
            ErrorMessage = @"Error retriving card infromation. Please contact customer support for more information.";
            
        }
        if (ErrorMessage.length > 0 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: ErrorMessage delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    [SVProgressHUD dismiss];
}

- (IBAction)btnClear_Click:(id)sender {
    [_txtCardNumber setText:@""];
    [_txtSecurityPin setText:@""];
    [_lblMessageTop setText:@""];
}
@end
