//
//  Logout.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/3/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "Logout.h"
#import <QuartzCore/QuartzCore.h>
#import "PACAppDelegate.h"

@interface Logout ()

@end

@implementation Logout

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
    [_btnYes useRedDeleteStyle];
    [_btnCancel useBlackStyle];
    _ActionViewBottomConstraint.constant  = 220;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //  self.view.backgroundColor = [UIColor clearColor];
    if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default_iPad_BG.png"]]];
        
    }
    else{
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"DefaultBG.png"]]];
    }
    [UIView animateWithDuration:0.8
                     animations:^{
                         _ActionViewBottomConstraint.constant= 0 ;
                         [self.view layoutIfNeeded];
                     }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Logout:(id)sender {
    PACAppDelegate* appdelegate = (PACAppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate LogoutUser];
}
- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
