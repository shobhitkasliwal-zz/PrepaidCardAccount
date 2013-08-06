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

#define LoginURL @"http://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/AuthenticateUser?UserName=%@&Password=%@&AuthenticationType=%@"

@interface LoginViewController ()
@property (strong, atomic) UILabel *lblText;
@property (strong,atomic) UIActivityIndicatorView* activity ;
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    //Assign new frame to your view
  //  [self.view setFrame:CGRectMake(0,-20,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
    [_vw_MainView addConstraint:[NSLayoutConstraint constraintWithItem:_vw_MainView
                      attribute:NSLayoutAttributeBottom
                      relatedBy:0
                         toItem:self.view
                      attribute:NSLayoutAttributeBottom
                     multiplier:0
                                                              constant:300.0f]];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
   // [self.view setFrame:CGRectMake(0,0,320,460)];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


-(BOOL) shouldAutorotate
{
    return YES;
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
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _activity.hidesWhenStopped = YES;
    [_activity setFrame:self.view.frame];
    // set a background color
    [_activity.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    CGPoint center = self.view.center;
    self.view.center = center;
    [self.view addSubview:_activity];
    [_activity startAnimating];
    
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
                        
                        bool isTest = false;
                        
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
                                   [CardInfo alloc] initWithCardNumber:[dict objectForKey:@"CardNumber"] andExpiration:[dict objectForKey:@"CardExpiration"] andBalance:[dict objectForKey:@"CardBalance"] andStatus:[dict objectForKey:@"CardStatus"] andProxy:[dict objectForKey:@"CardProxy"]  andWCSClientID:[dict objectForKey:@"WCSClientId"] 
                                   ]];
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
        [_lblText removeFromSuperview];
        [_activity stopAnimating];
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
