//
//  ManageUserCredentials.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/25/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "ManageUserCredentials.h"

@interface ManageUserCredentials ()

@end

@implementation ManageUserCredentials

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Home_Click:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}
@end
