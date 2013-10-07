//
//  CardActionDetail.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/6/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "CardActionDetail.h"


@interface CardActionDetail ()

@end

@implementation CardActionDetail

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
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDone_click:(id)sender {
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}


- (IBAction)btn_click:(id)sender {
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }

}
@end
