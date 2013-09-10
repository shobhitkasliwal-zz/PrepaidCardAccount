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
#define GetProfileURL @"http://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/GetUserProfile?Proxy=%@&WCSClientID=%@"


@interface UpdateProfile ()

@end

CardInfo *cInfo;
@implementation UpdateProfile

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
    self.navigationItem.title = @"Update Profile";
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    cInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
    NSMutableString *cardNumber = [NSMutableString stringWithString:[cInfo.cardNumber substringFromIndex:[cInfo.cardNumber length] - 6] ];
    [cardNumber insertString:@"-" atIndex:2];
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: xxxx-xxxx-xx", cardNumber ];
    [_lblHeaderCard setText:cardNumbertxt];
    
    _uiHeader.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _uiHeader.layer.cornerRadius = 8; // if you like rounded corners
    _uiHeader.layer.shadowOffset = CGSizeMake(-15, 20);
    _uiHeader.layer.shadowRadius = 5;
    _uiHeader.layer.shadowOpacity = 0.5;

    [SVProgressHUD showWithStatus:@"Retriving Profile.\n Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    [networkRequest makeWebCall:[NSString stringWithFormat:GetProfileURL,cInfo.cardProxy, cInfo.WcsClientID] httpMethod:RTHTTPMethodGET];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"UpdateProfileLogout" sender:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //responder = textField;
    
    if ([textField isEqual:_txtCountry]) {
        UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        [datepicker setDatePickerMode:UIDatePickerModeDate];
        
        textField.inputView = datepicker;
    }
    
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
    NSString* str = [NSString stringWithFormat:@"An error occured while retriving PIN.\n Please contact customer support for more details."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    
    if (responseArray != nil) {
    
    
    for (NSDictionary* dict in responseArray){
        
        if([dict count] == 1)
        {
            NSString* str = [dict objectForKey:@"Message"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
            [_txtFirstName setText:[dict objectForKey:@"FirstName"]];
            [_txtLastName setText:[dict objectForKey:@"LastName"]];
            [_txtAddress1 setText:[dict objectForKey:@"Address1"]];
            [_txtAddress2 setText:[dict objectForKey:@"Address2"]];
            [_txtCity setText:[dict objectForKey:@"City"]];
            [_txtState setText:[dict objectForKey:@"State"]];
            [_txtZip setText:[dict objectForKey:@"Zip"]];
            [_txtCountry setText:[dict objectForKey:@"Country"]];
            [_txtPhone setText:[dict objectForKey:@"Phone"]];
            
        }
    }
    
}
    
else
{
    NSString* str = [NSString stringWithFormat:@"An error occured while retriving PIN.\n Please contact customer support for more details."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
    
    
}


- (void)networkNotReachable{}
@end
