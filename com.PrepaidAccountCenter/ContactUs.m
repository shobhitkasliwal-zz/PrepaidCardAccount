//
//  ContactUs.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "ContactUs.h"
#import <QuartzCore/QuartzCore.h>

@interface ContactUs ()

@end
NSString* const CommentsWatermarkText = @"1000 characters maximum";
@implementation ContactUs

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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    [_btnReset useBlackStyle];
    [_btnSubmit useBlackStyle];
    [_txtComments.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_txtComments.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    _txtComments.layer.cornerRadius = 5;
    _txtComments.clipsToBounds = YES;
    
    _txtComments.text = CommentsWatermarkText;
    _txtComments.textColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        _navBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else
    {
        _navBar.barStyle = UIBarStyleBlackOpaque;
    }
    // Do any additional setup after loading the view from its nib.
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
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Done_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([_txtComments.text isEqualToString:CommentsWatermarkText]){
        _txtComments.text = @"";
        _txtComments.textColor = [UIColor blackColor];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_txtComments.text.length == 0){
        _txtComments.textColor = [UIColor lightGrayColor];
        _txtComments.text = CommentsWatermarkText;
        [_txtComments resignFirstResponder];
    }
}

- (IBAction)hideKeyBoard:(id)sender
{
    [_txtComments resignFirstResponder];
    [_txtFirstName resignFirstResponder];
    [_txtLastName resignFirstResponder];
    [_txtEmailAddress resignFirstResponder];
    [_txtPhoneNumber resignFirstResponder];
    if(_txtComments.text.length == 0){
        _txtComments.textColor = [UIColor lightGrayColor];
        _txtComments.text = CommentsWatermarkText;
        [_txtComments resignFirstResponder];
    }
    
}
- (IBAction)btnSubmit_Click:(id)sender {
}
- (IBAction)btnReset_Click:(id)sender {
    _txtComments.textColor = [UIColor lightGrayColor];
    _txtComments.text = CommentsWatermarkText;
    _txtFirstName.text =@"";
    _txtLastName.text =@"";
    _txtEmailAddress.text =@"";
    _txtPhoneNumber.text =@"";
}
@end
