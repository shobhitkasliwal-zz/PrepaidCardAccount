//
//  FaqAnswer.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/22/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "FaqAnswer.h"

@interface FaqAnswer ()

@end

@implementation FaqAnswer

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
   self.navigationItem.title = @"FAQ";
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    NSString* data = @"<table cellpadding=15 cellspacing=15 style='margin:0 auto; width:100%;'><tr><td>";
    data = [data stringByAppendingString:_Question];
    data = [data stringByAppendingString:@"</td></tr><tr><td>"];
    data = [data stringByAppendingString:_Answer];
    data = [data stringByAppendingString:@"</td></tr></table>"];
    //continue building the string
    [html appendString:data];
    [html appendString:@"</body></html>"];
    
   
    //make the background transparent
    //[_FaqAnswerWebView setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [_FaqAnswerWebView loadHTMLString:[html description] baseURL:nil];

   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Home_click:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
