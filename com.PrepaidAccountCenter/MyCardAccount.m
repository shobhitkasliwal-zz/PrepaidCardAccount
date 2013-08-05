//
//  MyCardAccount.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "MyCardAccount.h"
#import "UIColor+Hex.h"
@interface MyCardAccount ()

@end

@implementation MyCardAccount

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
    self.navigationItem.title = @"My Card Account";
  //  [appHelper applyShinyBackgroundWithColor:[UIColor redColor] forView:self.view];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"3F3F3F"], [UIColor colorWithHexString:@"9F9F9F"], nil];
     _uiViewHeader.colors= colors;
    
   // [_uiViewHeader app
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"MyCardAccountLogout" sender:nil];
}
@end
