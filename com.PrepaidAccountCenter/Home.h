//
//  PAC_LoggedIn_HomeViewController.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 6/11/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home : UITableViewController < UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *uiScrollCard;
@property (weak, nonatomic) IBOutlet UIPageControl *uiPageControlScrollCard;
@property (weak, nonatomic) IBOutlet UITableView *uiPageMainView;
@property (weak, nonatomic) IBOutlet UIView *uiContactUSView;
@property (weak, nonatomic) IBOutlet UIView *uiFaqView;
@property (weak, nonatomic) IBOutlet UIView *uiTermsView;
@end
