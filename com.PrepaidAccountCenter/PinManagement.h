//
//  PinManagement.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "GradientButton.h"
#import "RTNetworkRequest.h"

@interface PinManagement : UIViewController <RTNetworkRequestDelegate>
- (IBAction)LogoutClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderCard;
@property (weak, nonatomic) IBOutlet OBGradientView *uiHeader;
@property (weak, nonatomic) IBOutlet OBGradientView *uiPinView;
@property (weak, nonatomic) IBOutlet GradientButton *btnChangePin;
@property (weak, nonatomic) IBOutlet GradientButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtPin;

@property (weak, nonatomic) IBOutlet UILabel *lblViewPinMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_uiPinViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_CancelLeadingSpace;
@end
