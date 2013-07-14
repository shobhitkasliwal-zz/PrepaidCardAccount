//
//  TransactionsViewController.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Transactions: UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblOptions;

@property (weak, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCardExpiration;
@property (weak, nonatomic) IBOutlet UILabel *lblCardStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCardBalance;



@end
