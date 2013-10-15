//
//  CardActionDetail.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/6/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+KNSemiModal.h"
@interface CardActionDetail : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
- (IBAction)btnDone_click:(id)sender;
- (IBAction)btn_click:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;

@end
