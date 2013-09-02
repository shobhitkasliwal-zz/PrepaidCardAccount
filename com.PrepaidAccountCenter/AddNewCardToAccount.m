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
	// Do any additional setup after loading the view.
    _vwMain.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _vwMain.layer.cornerRadius = 8; // if you like rounded corners
    _vwMain.layer.shadowOffset = CGSizeMake(-15, 20);
    _vwMain.layer.shadowRadius = 5;
    _vwMain.layer.shadowOpacity = 0.5;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    [_lblMessageTop setText:@""];
    
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
    
}
- (IBAction)btnClear_Click:(id)sender {
    [_txtCardNumber setText:@""];
    [_txtSecurityPin setText:@""];
    [_lblMessageTop setText:@""];
}
@end
