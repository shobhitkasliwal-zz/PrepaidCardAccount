//
//  CardActionDetail.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/6/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+KNSemiModal.h"
#import "CardInfo.h"
#import "GradientButton.h"
@interface CardActionDetail : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
- (IBAction)btnDone_click:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak,nonatomic) CardInfo* cardInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtField1;
@property (weak, nonatomic) IBOutlet GradientButton *btnButton1;
- (IBAction)btnButton1_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblErrorMessage;
@property (weak, nonatomic)NSString* ActionType;
@property (nonatomic, assign) BOOL ActionSuccessful;

-(void) setupPopup: (CardInfo*) cinfo ForType:(NSString*) type;
@end
