//
//  PAC_LoginViewViewController.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 6/7/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RTNetworkRequest.h"
#import "SingletonGeneric.h"
#import "AppHelper.h"
#import "SVProgressHUD.h"

#define LoginURL @"http://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/AuthenticateUser?UserName=%@&Password=%@&AuthenticationType=%@"

@interface LoginViewController ()
@end

@implementation LoginViewController

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
    [_vw_MainView setHidden:NO];
    _vwLoginwithCard.layer.cornerRadius = 12.0;
    _vwLoginSwitch.layer.cornerRadius = 12.0;
    _txtUsernameCard.keyboardType = UIKeyboardTypeNumberPad;
    _txtPasswordSecPin.keyboardType = UIKeyboardTypeNumberPad;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    
}
- (void)keyboardDidShow:(NSNotification *)notification
{

    NSLog(@"%@", NSStringFromCGRect(_vw_MainView.superview.bounds));
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _vw_MainView.center = CGPointMake(_vw_MainView.center.x,
                                      _vw_MainView.center.y  - 50);
    [UIView commitAnimations];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _vw_MainView.center = CGPointMake(_vw_MainView.center.x,
                                      _vw_MainView.center.y  + 50);
    [UIView commitAnimations];
}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//
//-(BOOL) shouldAutorotate
//{
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SwitchCardUsernameLogin_ValueChanged:(UISwitch*)sender {
    
    [UIView transitionWithView:_vwLoginwithCard duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:^{
                        if (_SwitchCardUsernameLogin.isOn){
                            _lblCardNumberUsername.text = @"Username";
                            _lblPasswordSecurityCode.text = @"Password";
                            _txtUsernameCard.keyboardType = UIKeyboardTypeDefault;
                            _txtPasswordSecPin.keyboardType = UIKeyboardTypeDefault;
                        }
                        else
                        {
                            _lblCardNumberUsername.text = @"Card Number";
                            _lblPasswordSecurityCode.text = @"Security Code";
                            _txtUsernameCard.keyboardType = UIKeyboardTypeNumberPad;
                            _txtPasswordSecPin.keyboardType = UIKeyboardTypeNumberPad;
                        }
                        _vwLoginwithCard.alpha = 0.8;
                    }
                    completion:^(BOOL finished) {
                        _vwLoginwithCard.alpha = 1;
                        [_txtUsernameCard setText:@""];
                        [_txtPasswordSecPin setText:@""];
                        [_txtUsernameCard resignFirstResponder];
                        [_txtPasswordSecPin resignFirstResponder];
                       // [_txtUsernameCard becomeFirstResponder];
                    }];
    
}

- (IBAction)hideKeyBoard:(id)sender
{
    [_txtUsernameCard resignFirstResponder];
    [_txtPasswordSecPin resignFirstResponder];
    
}


- (IBAction)btnLogin_Click:(id)sender {
    [_vw_MainView setHidden:YES];
    [SVProgressHUD showWithStatus:@"You are being securely logging in. \nThank you for your patience." maskType:SVProgressHUDMaskTypeGradient];
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{
                        
                       
                        
                    }
                    completion:^(BOOL finished) {
                        
                        bool isTest = true;
                        
                        if (!isTest){
                        RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
                        if (_SwitchCardUsernameLogin.isOn)
                        {
                            NSString *Username = _txtUsernameCard.text;
                          //  NSData* data = [Username dataUsingEncoding:NSUTF8StringEncoding];
                          //NSData *datasend =   [AppHelper  TripleDES:data encryptOrDecrypt:kCCEncrypt key:@"AAECAwQFBgcICQoLDA0ODw=="];
                            [networkRequest makeWebCall:[NSString stringWithFormat:LoginURL,Username , _txtPasswordSecPin.text,@"Username"] httpMethod:RTHTTPMethodGET];
                        
                        }else
                            [networkRequest makeWebCall:[NSString stringWithFormat:LoginURL, _txtUsernameCard.text, _txtPasswordSecPin.text,@"Card"] httpMethod:RTHTTPMethodGET];
                        }
                        else{
                             [[SingletonGeneric UserCardInfo] RetriveUserCardInfo:@"Shobhit"];
                         [self performSelector:@selector(PresentLoggedinHomeView) withObject:nil afterDelay:0];
                        }
                    }];
    
    
    
}



#pragma mark - Service Caller Delegate

-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    NSString* ErrorMessage = @"";
    
    if (responseArray != nil) {
        
        NSMutableArray* cinfo = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in responseArray){
            if([dict count] == 1)
            {
                ErrorMessage = [dict objectForKey:@"Message"];
            }
            else{
                [cinfo addObject: [[CardInfo alloc] initWithDictionary:dict]];
                [ [SingletonGeneric UserCardInfo]setAllCardInfo:cinfo];
            }
        }
        
        
        
    }
    
    else
    {
        ErrorMessage = @"Please check your credentials.";
        
    }
    if (ErrorMessage.length == 0)
    {
        [self performSelector:@selector(PresentLoggedinHomeView) withObject:nil afterDelay:0];
    }
    
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: ErrorMessage delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [_vw_MainView setHidden:NO];
        [SVProgressHUD dismiss];
    }
    
    
}

- (void)networkNotReachable{}

- (void) PresentLoggedinHomeView
{
    UIStoryboard *LoggedinStoryBoard_iphone =[UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *userviewsVC =[LoggedinStoryBoard_iphone instantiateViewControllerWithIdentifier:@"NCHome"];
    userviewsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    userviewsVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:userviewsVC animated:YES completion:nil];
    //  [self dismissViewControllerAnimated:YES completion:nil];
      [SVProgressHUD dismiss];
}
-(void)serviceCallCompletedWithError:(NSError *)error
{}

@end
