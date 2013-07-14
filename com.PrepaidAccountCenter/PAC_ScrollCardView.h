//
//  PAC_ScrollCardView.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/13/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfo.h"
@interface PAC_ScrollCardView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblCardBalance;

@property (weak, nonatomic) IBOutlet UILabel *lblCardExpiration;
@property (strong, nonatomic) IBOutlet UIView *uiScrollCardView;


- (void) PopulateScrollCardView: (CardInfo*)card;
@end
