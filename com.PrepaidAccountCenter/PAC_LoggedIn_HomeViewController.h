//
//  PAC_LoggedIn_HomeViewController.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 6/11/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAC_LoggedIn_HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblOptions;

@property (weak, nonatomic) IBOutlet UIScrollView *uiScrollCard;


@property (weak, nonatomic) IBOutlet UIPageControl *uiPageControlScrollCard;

@property (strong, nonatomic) IBOutlet UIView *uiPageMainView;


@end
