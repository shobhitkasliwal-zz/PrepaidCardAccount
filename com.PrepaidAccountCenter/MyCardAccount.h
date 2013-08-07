//
//  MyCardAccount.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "iCarousel.h"

@interface MyCardAccount : UIViewController <iCarouselDataSource, iCarouselDelegate>
- (IBAction)LogoutClick:(id)sender;

@property (weak, nonatomic) IBOutlet OBGradientView *uiViewHeader;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@end
