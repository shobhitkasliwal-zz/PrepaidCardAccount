//
//  CardActionDetail.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/6/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "CardActionDetail.h"
#import "SVProgressHUD.h"
#import "SingletonGeneric.h"

#define SECONDARY_AUTH_BUTTON_TAG 1
#define ACTIVATE_CARD_BUTTON_TAG 2
@interface CardActionDetail ()

@end

CGFloat CurrentPopupHeight;
@implementation CardActionDetail

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
    _txtField1.delegate = self;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    CurrentPopupHeight = self.view.frame.size.height;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    _lblTop.numberOfLines = 0;
    [_navTitle.titleView sizeToFit];
    [_btnButton1 useBlackStyle];
    [_btnButton1 sizeToFit];
    [_btnButton1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
    
    [_lblTop sizeToFit];
}

-(void) setupPopup: (CardInfo*) cinfo ForType:(NSString*) type
{
    
    _ActionType = type;
    _ActionSuccessful = NO;
    [_btnButton1 setHidden:YES];
    [_txtField1 setHidden:YES];
    [_lblErrorMessage setHidden:YES];
    _cardInfo = cinfo;
    if(!_cardInfo.CIPPassed)
    {
        _lblTop.text =@"You are not allowed to access the app for this card. Please go to www.prepaidcardstatus.com and complete the process.";
        _navTitle.title = @"CIP Validation Required";
        
    }
    else if(_cardInfo.UserRegistrationRequired)
    {
        _lblTop.text =@"You are not allowed to currently access this card. Please review and update your profile first.";
        _navTitle.title = @"Registration Required";
    }
    else if(_cardInfo.UserSecondaryAuthRequired)
    {
        _lblTop.text = _cardInfo.Sec_Auth_Label;
        _navTitle.title = @"Secondary Authentication Required";
        [_txtField1 setHidden:NO];
        [_btnButton1 setHidden:NO];
        _btnButton1.titleLabel.text = @"Authenticate";
        [_btnButton1 setTitle:@"Authenticate" forState:UIControlStateNormal];
        
        _btnButton1.tag = SECONDARY_AUTH_BUTTON_TAG;
        
    }
    else if([_cardInfo.cardStatus caseInsensitiveCompare:@"Closed"] == NSOrderedSame)
    {
        _lblTop.text =@"The card is in closed status. Please contact customer support for more details.";
        _navTitle.title = @"Closed Card";
    }
    else if ([_cardInfo.cardStatus caseInsensitiveCompare:@"Ready"] == NSOrderedSame)
    {
        _lblTop.text =[NSString stringWithFormat: @"Please activate the card %@ . ", _cardInfo.cardNumber];
        _navTitle.title = @"Activate Card";
        
        [_btnButton1 setHidden:NO];
        _btnButton1.tag = ACTIVATE_CARD_BUTTON_TAG;
        [_btnButton1 setTitle:@"Activate" forState:UIControlStateNormal];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDone_click:(id)sender {
    [self dismissSemiModalView];
    // UIViewController * parent = [self.view containingViewController];
    //if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
    //   [parent dismissSemiModalView];
    // }
}


- (IBAction)btnButton1_Click:(id)sender {
    switch (_btnButton1.tag)
    {
            
        case ACTIVATE_CARD_BUTTON_TAG:
        {
            [SVProgressHUD showWithStatus:@"Activating Card. \nPlease wait ... " maskType:SVProgressHUDMaskTypeGradient];
            RTNetworkRequest* activateRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
            activateRequest.currentCallType = [NSMutableString stringWithString:@"ActivateCard"];
            [activateRequest makeWebCall:[NSString stringWithFormat:ACTIVATE_CARD_SERVICE,_cardInfo.cardProxy, _cardInfo.WcsClientID] httpMethod:RTHTTPMethodGET];
        }
            break;
        case SECONDARY_AUTH_BUTTON_TAG:
        {
            [SVProgressHUD showWithStatus:@"Validating Credentials.\nPlease wait ..." maskType:SVProgressHUDMaskTypeGradient];
            RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
            networkRequest.currentCallType = [NSMutableString stringWithString:@"SecondaryAuthenticateUser"];
            [networkRequest makeWebCall:[NSString stringWithFormat:SECONDARY_AUTHENTICATE_USER,_cardInfo.cardProxy, _cardInfo.WcsClientID,_cardInfo.SiteConfigID,_txtField1.text] httpMethod:RTHTTPMethodGET];
        }   break;
            
    }
}

-(void) serviceCallCompletedWithError:(NSError*) error
{
    
    [SVProgressHUD dismiss];
    NSString* str = [NSString stringWithFormat:@"An error occured while accessing service.\n Please contact customer support for more details."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    _ActionSuccessful = NO;
    [alert show];
    
}
-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    if ([currentCallType isEqualToString:@"SecondaryAuthenticateUser"])
    {
        for (NSDictionary* dict in responseArray){
            if([dict objectForKey:@"Message"] )
            {
                if ([[[dict objectForKey:@"Message"] uppercaseString] isEqualToString:@"SUCCESS"])
                {
                    _cardInfo.UserSecondaryAuthRequired = 0;
                    [[SingletonGeneric UserCardInfo] updateCardInfo:_cardInfo];
                    _ActionSuccessful = YES;
                    [self dismissSemiModalView];
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [dict objectForKey:@"Message"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                NSString* str = [NSString stringWithFormat:@"Please enter the correct value for %@", _cardInfo.Sec_Auth_Label];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    else  if ([currentCallType isEqualToString:@"ActivateCard"])
    {
        for (NSDictionary* dict in responseArray){
            if([dict objectForKey:@"Message"] )
            {
                if ([[[dict objectForKey:@"Message"] uppercaseString] isEqualToString:@"SUCCESS"])
                {
                    _cardInfo.cardStatus = @"Active";
                    [[SingletonGeneric UserCardInfo] updateCardInfo:_cardInfo];
                    _ActionSuccessful = YES;
                    [self dismissSemiModalView];
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [dict objectForKey:@"Message"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                NSString* str = [NSString stringWithFormat:@"Please enter the correct value for %@", _cardInfo.Sec_Auth_Label];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    
}

- (void)networkNotReachable{
    [SVProgressHUD dismiss];
    NSString* str = [NSString stringWithFormat:@"Network not available. Please try again later."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)hideKeyBoard:(id)sender
{
    [_txtField1 resignFirstResponder];
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self changeHeightSemiView: CurrentPopupHeight];
    // self.view.center =  CGPointMake(self.view.center.x,
    //                               self.view.center.y  - keyboardSize.height);
    [UIView commitAnimations];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [self changeHeightSemiView:CurrentPopupHeight + keyboardSize.height];
    [UIView commitAnimations];
    //your other code here..........
}

@end
