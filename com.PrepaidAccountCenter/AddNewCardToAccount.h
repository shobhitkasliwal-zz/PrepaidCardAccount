//
//  AddNewCardToAccount.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/31/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "GradientButton.h"
#import "RTNetworkRequest.h"
@interface AddNewCardToAccount : UIViewController <RTNetworkRequestDelegate>
@property (weak, nonatomic) IBOutlet OBGradientView *vwMain;
@property (strong, nonatomic) IBOutlet UIView *vwPageTopView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)btnHome_Click:(id)sender;
@property (weak, nonatomic) IBOutlet GradientButton *btnAddCard;

- (IBAction)btnAddCard_Click:(id)sender;

@property (weak, nonatomic) IBOutlet GradientButton *btnClear;
@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtSecurityPin;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageTop;

- (IBAction)btnClear_Click:(id)sender;
@end
