//
//  VCHome.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/28/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCHome : UIViewController < UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *uiScrollCard;
@property (weak, nonatomic) IBOutlet UIPageControl *uiPageControlScrollCard;
@property (weak, nonatomic) IBOutlet UITableView *uiPageMainView;


-(IBAction)contactUSButtonClicked:(id)sender;
-(IBAction)faqButtonClicked:(id)sender;
-(IBAction)termsButtonClicked:(id)sender;

@end
