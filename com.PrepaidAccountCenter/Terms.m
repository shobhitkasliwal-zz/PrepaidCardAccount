//
//  Terms.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "Terms.h"
#import "SVProgressHUD.h"
#import "AppConstants.h"
#import "CardInfo.h"
#import "SingletonGeneric.h"

@interface Terms ()

@end
CardInfo *cInfo;
@implementation Terms

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
    cInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
    
    // Do any additional setup after loading the view from its nib.
    [SVProgressHUD showErrorWithStatus:@"Retriving Terms"];
    
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    networkRequest.currentCallType = [NSMutableString stringWithString:@"CreateCredentialCall"];
    [networkRequest makeWebCall:[NSString stringWithFormat:TERM_SERVICE_URL, cInfo.SiteConfigID] httpMethod:RTHTTPMethodGET];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
       
        _navBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else
    {
        _navBar.barStyle = UIBarStyleBlackOpaque;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    if (responseArray != nil) {
        for (NSDictionary* dict in responseArray){
        [_wvTerms loadHTMLString: [dict objectForKey:@"TermValue"] baseURL:nil];
        //[_tblFaq reloadData];
        }
    }}

-(void)serviceCallCompletedWithError: (NSError *) error
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: INTERNET_NOT_AVAILABLE_POPUP_TITLE message: INTERNET_NOT_AVAILABLE_POPUP_TEXT delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];


}
- (void)networkNotReachable{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: INTERNET_NOT_AVAILABLE_POPUP_TITLE message: INTERNET_NOT_AVAILABLE_POPUP_TEXT delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (IBAction)Done_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
