//
//  FaqAnswer.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/22/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaqAnswer : UIViewController

- (IBAction)Home_click:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *FaqAnswerWebView;
@property (weak, nonatomic) NSString* Question;
@property (weak, nonatomic) NSString* Answer;
@end
