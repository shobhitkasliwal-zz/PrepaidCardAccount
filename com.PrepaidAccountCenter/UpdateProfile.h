//
//  UpdateProfile.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "RTNetworkRequest.h"
#import "SVProgressHUD.h"
#import "GradientButton.h"

@interface UpdateProfile : UIViewController <UIPickerViewDelegate, RTNetworkRequestDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
- (IBAction)LogoutClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderCard;
@property (weak, nonatomic) IBOutlet OBGradientView *uiHeader;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress1;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress2;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
- (IBAction)btnUpdateProfile_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwForm;
@property (weak, nonatomic) IBOutlet UIScrollView *formScrollView;

@property (weak, nonatomic) IBOutlet GradientButton *btnUpdateProfile;
@end
