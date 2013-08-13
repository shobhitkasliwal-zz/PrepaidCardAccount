//
//  TransactionsViewController.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "RTNetworkRequest.h"

@interface Transactions: UIViewController <UITableViewDelegate, UITableViewDataSource,  RTNetworkRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblOptions;

@property (weak, nonatomic) IBOutlet UILabel *lblCardNumber;

@property (weak, nonatomic) IBOutlet OBGradientView *uiHeader;

- (IBAction)LogoutClick:(id)sender;
-(void) GetTransactions :(int) NumberofDays;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@end
