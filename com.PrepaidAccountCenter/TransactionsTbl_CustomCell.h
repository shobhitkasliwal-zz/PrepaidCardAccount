//
//  PACLoggedinHome_CustomTableCell.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 6/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsTbl_CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAuthDateValue;
@property (weak, nonatomic) IBOutlet UILabel *lblPostDateValue;

@property (weak, nonatomic) IBOutlet UILabel *lblMerchantName;

@property (weak, nonatomic) IBOutlet UILabel *lblResponseReason;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;

@end
