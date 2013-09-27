//
//  VCHome.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/28/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "OBGradientView.h"
@interface VCHome : UIViewController < UITableViewDelegate, UITableViewDataSource, iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *uiPageControlScrollCard;
@property (weak, nonatomic) IBOutlet UITableView *uiPageMainView;
@property (weak, nonatomic) IBOutlet iCarousel *CardScrollView;
- (IBAction)PageChange:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLogout;
- (IBAction)Credentials_click:(id)sender;

- (IBAction)LogoutClick:(id)sender;
-(IBAction)contactUSButtonClicked:(id)sender;
-(IBAction)faqButtonClicked:(id)sender;
-(IBAction)termsButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SC_CardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SC_Expiration;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SC_Balance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SC_Status;
@property (strong, nonatomic) IBOutlet OBGradientView *vw_SC_View;
@property (weak, nonatomic) IBOutlet UIView *vw_ScrollWrapper;
@property (weak, nonatomic) IBOutlet OBGradientView *vwBottomInfoBar;

@end
