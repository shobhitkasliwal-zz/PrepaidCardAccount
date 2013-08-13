//
//  PinManagement.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "PinManagement.h"
#import "SingletonGeneric.h"
#import "UIColor+Hex.h"
@interface PinManagement ()

@end
CardInfo *cInfo;
@implementation PinManagement

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Pin Management";
    cInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
    NSMutableString *cardNumber = [NSMutableString stringWithString:[cInfo.cardNumber substringFromIndex:[cInfo.cardNumber length] - 6] ];
    [cardNumber insertString:@"-" atIndex:2];
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: xxxx-xxxx-xx", cardNumber ];
    [_lblHeaderCard setText:cardNumbertxt];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _uiHeader.colors = colors;
    _uiHeader.layer.cornerRadius = 8; // if you like rounded corners
    _uiHeader.layer.shadowOffset = CGSizeMake(-15, 20);
    _uiHeader.layer.shadowRadius = 5;
    _uiHeader.layer.shadowOpacity = 0.5;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutClick:(id)sender {
     [self performSegueWithIdentifier:@"PinManagementLogout" sender:nil];
}
@end
