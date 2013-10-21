//
//  CardActionDetail.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/6/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "CardActionDetail.h"
#import "SVProgressHUD.h"

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
            
        case SECONDARY_AUTH_BUTTON_TAG:
            //[SVProgressHUD showWithStatus:@"Please wait ..." maskType:SVProgressHUDMaskTypeGradient];
            _ActionSuccessful = YES;
            [self dismissSemiModalView];
            break;
        case ACTIVATE_CARD_BUTTON_TAG:
             //[SVProgressHUD showWithStatus:@"Activating Card. \nPlease wait ... " maskType:SVProgressHUDMaskTypeGradient];
            break;
    }
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
