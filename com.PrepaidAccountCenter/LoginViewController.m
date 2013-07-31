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

#define LoginURL @"http://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/AuthenticateUser?UserName=%@&Password=%@&AuthenticationType=%@"

@interface LoginViewController ()
@property (strong, atomic) UILabel *lblText;
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
    _vwLoginwithCard.layer.cornerRadius = 12.0;
    _vwLoginSwitch.layer.cornerRadius = 12.0;
    _txtUsernameCard.keyboardType = UIKeyboardTypeNumberPad;
    _txtPasswordSecPin.keyboardType = UIKeyboardTypeNumberPad;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
}

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
                    }];
    
}

- (IBAction)hideKeyBoard:(id)sender
{
    [_txtUsernameCard resignFirstResponder];
    [_txtPasswordSecPin resignFirstResponder];
    
}


- (IBAction)btnLogin_Click:(id)sender {
    
    _lblText = [[UILabel alloc] init];
    _lblText.textAlignment = NSTextAlignmentCenter;
    _lblText.numberOfLines = 0 ;
    _lblText.text =[NSString stringWithFormat:@"You are being securely logging in. \nThanks for your patience."];
    _lblText.backgroundColor = [UIColor clearColor];
    _lblText.textColor = [UIColor whiteColor];
    [_lblText sizeToFit];
    [_vw_MainView setHidden:YES];
    
    
    
    
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        
                        [_lblText addConstraint:[NSLayoutConstraint constraintWithItem:_lblText
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:0
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                                            multiplier:1.0f
                                                                              constant:300.0f]];
                        _lblText.translatesAutoresizingMaskIntoConstraints = NO;
                        
                        
                        [self.view addSubview:_lblText];
                        
                        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lblText
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1.0f
                                                                               constant:0.0f]];
                        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_lblText
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.view
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1.0f
                                                                               constant:0.0f]];
                        
                        
                    }
                    completion:^(BOOL finished) {
                        RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
                        if (_SwitchCardUsernameLogin.isOn)
                            [networkRequest makeWebCall:[NSString stringWithFormat:LoginURL, _txtUsernameCard.text, _txtPasswordSecPin.text,@"Username"] httpMethod:RTHTTPMethodGET];
                        else
                            [networkRequest makeWebCall:[NSString stringWithFormat:LoginURL, _txtUsernameCard.text, _txtPasswordSecPin.text,@"Card"] httpMethod:RTHTTPMethodGET];
                    }];
    
    
    
}



#pragma mark - Service Caller Delegate

-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    NSString* ErrorMessage = @"";
    
    if (responseArray != nil) {
        NSLog(@"array: %@", responseArray);
        NSMutableArray* cinfo = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in responseArray){
            NSLog(@"array: %@", dict);
            if([dict count] == 1)
            {
                ErrorMessage = [dict objectForKey:@"Message"];
            }
            else{
                [cinfo addObject: [
                                   [CardInfo alloc] initWithCardNumber:[dict objectForKey:@"CardNumber"] andExpiration:[dict objectForKey:@"CardExpiration"] andBalance:[dict objectForKey:@"CardBalance"] andStatus:[dict objectForKey:@"CardStatus"]
                                   ]];
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
        [_lblText removeFromSuperview];
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
    
}

@end
