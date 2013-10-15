//
//  ContactUs.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"

@interface ContactUs : UIViewController
- (IBAction)Done_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtComments;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet GradientButton *btnSubmit;
- (IBAction)btnSubmit_Click:(id)sender;
@property (weak, nonatomic) IBOutlet GradientButton *btnReset;

- (IBAction)btnReset_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
