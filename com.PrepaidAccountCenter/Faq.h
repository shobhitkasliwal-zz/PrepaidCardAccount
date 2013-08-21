//
//  Faq.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "GradientButton.h"
#import "RTNetworkRequest.h"

@interface Faq : UIViewController <UITableViewDelegate, UITableViewDataSource,  RTNetworkRequestDelegate>
- (IBAction)Done_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderCard;
@property (weak, nonatomic) IBOutlet OBGradientView *uiHeader;
@end
