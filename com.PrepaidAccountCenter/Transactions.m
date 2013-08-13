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
#import "SVProgressHUD.h"


#define GetTransactionURL @"http://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/GetTransactions?Proxy=%@&NoofDays=%@&WCSClientID=%@"
@interface Transactions ()
@property (nonatomic, strong) NSMutableArray *CardTransactions;
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
    _CardTransactions = [[NSMutableArray alloc] init];
    
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
    [_tblOptions setHidden:YES];
    [_lblMessage setHidden:YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(GetTransactions:) userInfo:[NSNumber numberWithInt:365] repeats:NO];
//    [self GetTransactions:365];
}

-(void) GetTransactions :(int) NumberofDays
{
//    [SVProgressHUD showWithStatus:@"Retriving Transactions.\n Please Wait..." maskType:SVProgressHUDMaskTypeGradient];

    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    [networkRequest makeWebCall:[NSString stringWithFormat:GetTransactionURL,cInfo.cardProxy,[NSString stringWithFormat:@"%d",NumberofDays], cInfo.WcsClientID] httpMethod:RTHTTPMethodGET];
}
-(void) serviceCallCompletedWithError:(NSError*) error
{
    
    [SVProgressHUD dismiss];
    _lblMessage.text = @"An error occured while retriving transactions.\n Please contact customer support for more details.";
    [_lblMessage setHidden:NO];
    [_tblOptions setHidden:YES];
  
}
-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    if (responseArray != nil) {
        NSLog(@"array: %@", responseArray);
       
        for (NSDictionary* dict in responseArray){
            NSLog(@"array: %@", dict);
            [ _CardTransactions  addObject:dict];
        }
        [_tblOptions reloadData];
        [_tblOptions setHidden:NO];
        [_lblMessage setHidden:YES];
    }

    else
    {
        _lblMessage.text =  @"There are no Transactions avilable for this card account. Please change the duration below to get the older transactions." ;
        [_tblOptions setHidden:YES];
        [_lblMessage setHidden:NO];
    }
    
    
    
}

- (void)networkNotReachable{
    _lblMessage.text = @"Network Error !!!. Please contact customer support." ;
    [_tblOptions setHidden:YES];
    [_lblMessage setHidden:NO];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    return ( _CardTransactions.count);
    
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    TransactionsTbl_CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TransactionsTbl_CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(_CardTransactions.count > indexPath.row)
    {
    NSDictionary* dict = [_CardTransactions objectAtIndex:[indexPath row]];
    if (dict != nil){
    [cell.lblAuthDateValue setText: [dict objectForKey:@"AUTHDATE"]];
    [cell.lblPostDateValue setText:[dict objectForKey:@"POSTDATE"] ];
     [cell.lblMerchantName setText:[dict objectForKey:@"MERCHANTNAME"] ];
     [cell.lblResponseReason setText:[dict objectForKey:@"TXNTYPE"] ];
    [cell.lblAmount setText:[NSString stringWithFormat:@"%@%@",@"USD ",[dict objectForKey:@"POSTAMOUNT"]]];
  //  cell.contentView.backgroundColor = [UIColor colorWithRed:99/255.f green:184/255.f blue:255/255.f alpha:1];
    }
    }
    return cell;
    
}

- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"TransactionsLogout" sender:nil];
    
}
@end
