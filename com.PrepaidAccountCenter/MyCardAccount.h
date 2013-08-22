//
//  MyCardAccount.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "GradientButton.h"

@interface MyCardAccount : UIViewController < UITableViewDelegate, UITableViewDataSource>
- (IBAction)LogoutClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblCards;
@property (weak, nonatomic) IBOutlet OBGradientView *uiViewHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnByBalance;
@property (weak, nonatomic) IBOutlet GradientButton *btnAddNewCard;
@property (weak, nonatomic) IBOutlet UIButton *btnByExpiry;
@property (weak, nonatomic) IBOutlet UIButton *btnByStatus;
- (IBAction)btnByExpiry_click:(id)sender;
- (IBAction)btnByBalance_click:(id)sender;
- (IBAction)btnByStatus_click:(id)sender;
@end
