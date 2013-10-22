//
//  AppInfoViewController.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/3/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

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
	// Do any additional setup after loading the view.
    [_btnDone useBlackStyle];
    
   
    
    _lblMessage.numberOfLines = 0;
    NSString* string = [NSString stringWithFormat:@"Copyright 2004-2013 Swift Prepaid Solutions, Inc.\nwww.prepaidcardstatus.com\n Build Date : 10/21/2013\nVersion:1.0.0.101"];
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 30.f;
    style.maximumLineHeight = 30.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    _lblMessage.attributedText = [[NSAttributedString alloc] initWithString:string
                                                             attributes:attributtes];
    [_lblMessage sizeToFit];
    _lblMessage.textAlignment = NSTextAlignmentCenter;

}
- (void)viewDidAppear:(BOOL)animated
{
     self.view.backgroundColor = [UIColor clearColor];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done_click:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
