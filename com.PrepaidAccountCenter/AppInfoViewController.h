//
//  AppInfoViewController.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/3/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"
@interface AppInfoViewController : UIViewController
- (IBAction)done_click:(id)sender;
@property (weak, nonatomic) IBOutlet GradientButton *btnDone;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

@end
