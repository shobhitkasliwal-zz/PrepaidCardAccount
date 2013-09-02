//
//  ManageUserCredentials.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/25/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "GradientButton.h"
#import "UIColor+Hex.h"

@interface ManageUserCredentials : UIViewController
- (IBAction)Home_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPAssword;

@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPAssword;
@property (weak, nonatomic) IBOutlet GradientButton *btnCreate;
@property (weak, nonatomic) IBOutlet GradientButton *btnCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vwHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblOldPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constlblPassword;
@property (weak, nonatomic) IBOutlet OBGradientView *vwMain;
- (IBAction)btnCreate_Click:(id)sender;
- (IBAction)btnReset_Click:(id)sender;
@end
