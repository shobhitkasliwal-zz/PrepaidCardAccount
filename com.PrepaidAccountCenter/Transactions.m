//
//  TransactionsViewController.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "Transactions.h"
#import "TransactionsTbl_CustomCell.h"
#import "SingletonGeneric.h"
#import "CardInfo.h"
#import "UIColor+Hex.h"
#import <QuartzCore/QuartzCore.h>
#import "RTNetworkRequest.h"


#define GetTransactionURL @"http://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/GetTransactions?Proxy=%@&NoofDays=%@&WCSClientID=%@"
@interface Transactions ()

@property (nonatomic, strong) NSMutableArray *CardTransactions;
@property (nonatomic,strong) UIActivityIndicatorView *tableActivityIndicator;
@end
CardInfo *cInfo;
@implementation Transactions

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
    [_tblOptions setHidden:YES];
    _tableActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    //[self activi = activity;
    
    // make the area larger
    _tableActivityIndicator.hidesWhenStopped = YES;
    CGRect screenrect = [[UIScreen mainScreen] bounds];
   [_tableActivityIndicator setFrame:screenrect];
    // set a background color
    [_tableActivityIndicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
    CGPoint center = self.view.center;
    _tableActivityIndicator.center = center;
    [self.view addSubview:_tableActivityIndicator];
    [_tableActivityIndicator startAnimating];
    [self GetTransactions:365];
	// Do any additional setup after loading the view.
       
cInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
    NSMutableString *cardNumber = [NSMutableString stringWithString:[cInfo.cardNumber substringFromIndex:[cInfo.cardNumber length] - 6] ];
    [cardNumber insertString:@"-" atIndex:2];
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: xxxx-xxxx-xx", cardNumber ];
    [_lblCardNumber setText:cardNumbertxt];
  
    self.navigationItem.title=@"Transactions";
        NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _uiHeader.colors = colors;
    _uiHeader.layer.cornerRadius = 8; // if you like rounded corners
    _uiHeader.layer.shadowOffset = CGSizeMake(-15, 20);
    _uiHeader.layer.shadowRadius = 5;
    _uiHeader.layer.shadowOpacity = 0.5;
    
    
    
}


-(void) GetTransactions :(int) NumberofDays
{
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    [networkRequest makeWebCall:[NSString stringWithFormat:GetTransactionURL,cInfo.cardProxy,[NSString stringWithFormat:@"%d",NumberofDays], cInfo.WcsClientID] httpMethod:RTHTTPMethodGET];
}

-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    if (responseArray != nil) {
        NSLog(@"array: %@", responseArray);
        _CardTransactions = [[NSMutableArray alloc] init];
        for (NSDictionary* dict in responseArray){
            NSLog(@"array: %@", dict);
            [ _CardTransactions  addObject:dict];
        }
[_tblOptions reloadData];
        [_tblOptions setHidden:NO];
    }

    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"An Error occured while retriving data. Please contact customer support." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    [_tableActivityIndicator stopAnimating];
    
    
}

- (void)networkNotReachable{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"Network Error !!!. Please contact customer support." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    CAGradientLayer *bgLayer = [appHelper greyGradient];
//    bgLayer.frame = _uiHeader.bounds;
//    [_uiHeader.layer insertSublayer:bgLayer atIndex:0];

 //   [appHelper applyShinyBackgroundWithColor:[UIColor redColor] forView:_uiHeader];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (sizeof _CardTransactions);
    
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    
    
    TransactionsTbl_CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[TransactionsTbl_CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    
    NSDictionary* dict = [_CardTransactions objectAtIndex:[indexPath row]];
    if (dict != nil){
    [cell.lblAuthDateValue setText: [dict objectForKey:@"AUTHDATE"]];
    [cell.lblPostDateValue setText:[dict objectForKey:@"POSTDATE"] ];
     [cell.lblMerchantName setText:[dict objectForKey:@"MERCHANTNAME"] ];
     [cell.lblResponseReason setText:[dict objectForKey:@"TXNTYPE"] ];
    [cell.lblAmount setText:[NSString stringWithFormat:@"%@%@",@"USD ",[dict objectForKey:@"POSTAMOUNT"]]];
  //  cell.contentView.backgroundColor = [UIColor colorWithRed:99/255.f green:184/255.f blue:255/255.f alpha:1];
    }
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // open a alert with an OK and cancel button
    
//    NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
//    
//    [alert show];
    
    
    
}



- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"TransactionsLogout" sender:nil];
    
}
@end
