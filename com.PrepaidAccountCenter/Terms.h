//
//  Terms.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTNetworkRequest.h"
@interface Terms : UIViewController <RTNetworkRequestDelegate, UIWebViewDelegate>
- (IBAction)Done_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *wvTerms;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
