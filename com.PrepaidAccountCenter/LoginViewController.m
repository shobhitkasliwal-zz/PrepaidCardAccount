//
//  PAC_LoginViewViewController.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 6/7/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

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


    NSLog(@"%@", NSStringFromCGRect(_vwLoginwithCard.frame));

   
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
    
CGRect frame = _vw_MainView.frame;
    UIView *subView = [[UIView alloc] initWithFrame:frame];
    subView.backgroundColor =_vw_MainView.backgroundColor;
    UILabel *lblText = [[UILabel alloc] init];
    lblText.frame = CGRectMake(30,50,260,250);
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.text =[NSString stringWithFormat:@"You are being securely logging in. Thanks for your patience."];
    lblText.numberOfLines = 0;
    lblText.backgroundColor =_vw_MainView.backgroundColor;
    lblText.textColor = [UIColor whiteColor];
    
     [subView addSubview: lblText];
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.view addSubview:subView];
                        
                    }
                    completion:^(BOOL finished) {
                        
                           
                        [self performSelector:@selector(PresentLoggedinHomeView) withObject:nil afterDelay:1];
                        
                       
                        
                    }];
     
    

}
 - (void) PresentLoggedinHomeView 
{
    UIStoryboard *LoggedinStoryBoard_iphone =[UIStoryboard storyboardWithName:@"LoggedinStoryBoard_iphone" bundle:nil];
    UINavigationController *userviewsVC =[LoggedinStoryBoard_iphone instantiateViewControllerWithIdentifier:@"LoggedIn_HomeViewController"];
    userviewsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    userviewsVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:userviewsVC animated:YES completion:nil];
  //  [self dismissViewControllerAnimated:YES completion:nil];

}

@end
