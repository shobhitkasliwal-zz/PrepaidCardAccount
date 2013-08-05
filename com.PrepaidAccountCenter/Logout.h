//
//  Logout.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/3/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"

@interface Logout : UIViewController
@property (weak, nonatomic) IBOutlet GradientButton *btnYes;
- (IBAction)Logout:(id)sender;
@property (weak, nonatomic) IBOutlet GradientButton *btnCancel;
- (IBAction)Cancel:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ActionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *uiActionButtons;
@end
