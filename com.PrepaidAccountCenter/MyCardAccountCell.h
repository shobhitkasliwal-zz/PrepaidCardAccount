//
//  MyCardAccountCell.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/5/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "CardInfo.h"


@interface MyCardAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMCA_CardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblMCA_ExpDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMCACardStatus;
@property (weak, nonatomic) IBOutlet OBGradientView *myView;
@property (weak, nonatomic) IBOutlet UILabel *lblMCA_CardType;
@property (weak, nonatomic) IBOutlet UILabel *lblMCA_CardBalance;
@property( nonatomic, assign) BOOL enableBalanceLink;

-(void) populateCell:(CardInfo*) cardInfo;

@end
