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
#import "AppConstants.h"
@interface Transactions ()
@property (nonatomic, strong) NSMutableArray *CardTransactions;
@end
CardInfo *cInfo;
int CurrentTransactionDuration;
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
   
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: ", cInfo.cardNumber ];
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
    [_btnLast30Days useBlackStyle];
    [_btnLast90Days useBlackStyle];
    [_btnLast365Days useBlackStyle];
    [_btnLast30Days setEnabled:NO];

}

-(void)viewDidAppear:(BOOL)animated
{
  //  [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(GetTransactions:) userInfo:[NSNumber numberWithInt:365] repeats:NO];
   CurrentTransactionDuration = 30;
    [self GetTransactions:30];
    self.view.backgroundColor = [UIColor clearColor];
    
    
}

-(void) GetTransactions :(int) NumberofDays
{
    [SVProgressHUD showWithStatus:@"Retriving Transactions.\n Please Wait..." maskType:SVProgressHUDMaskTypeGradient];

    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    [networkRequest makeWebCall:[NSString stringWithFormat:GET_TRANSACTION_SERVICE_URL,cInfo.cardProxy,[NSString stringWithFormat:@"%d",NumberofDays], cInfo.WcsClientID] httpMethod:RTHTTPMethodGET];
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
        _lblMessage.text =  @"There are no Transactions avilable for this card account. Please change the duration below to get the past transactions." ;
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
- (IBAction)btnChangeDuration:(id)sender {
    [_btnLast30Days setEnabled:YES];
    [_btnLast90Days setEnabled:YES];
    [_btnLast365Days setEnabled:YES];
    UIButton* button = (UIButton *)sender;
    if(button == _btnLast30Days)
    {
        if(CurrentTransactionDuration != 30)
        {
            CurrentTransactionDuration =30;
            [self GetTransactions:30];
            [_btnLast30Days setEnabled:NO];
        }
    }
    else if (button == _btnLast90Days){
        if(CurrentTransactionDuration != 90){
            CurrentTransactionDuration = 90;
            [self GetTransactions:90];
            [_btnLast90Days setEnabled:NO];
        }
    }
    else if (button == _btnLast365Days)
    {
        
        if (CurrentTransactionDuration != 365){
            CurrentTransactionDuration = 365;
            [self GetTransactions:365];
            [_btnLast365Days setEnabled:NO];
        }
    }
    else
    {
        CurrentTransactionDuration = 720;
        [self GetTransactions:720];
    }
}
@end
