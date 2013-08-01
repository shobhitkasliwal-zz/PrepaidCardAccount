//
//  VCHome.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/28/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "VCHome.h"
#import "CardInfo.h"
#import "SingletonGeneric.h"
#import "PAC_ScrollCardView.h"
#import <QuartzCore/QuartzCore.h>
#import "ContactUs.h"
#import "Terms.h"
#import "Faq.h"

@interface VCHome ()
@property (nonatomic, strong)NSArray *dsTableViewRows;
@property (nonatomic, strong) NSArray *pageCardInformation;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic,strong) UIActivityIndicatorView *tableActivityIndicator;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end
int CurrentScrollViewPage;
@implementation VCHome


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
    _dsTableViewRows = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"My Card Account", @"MyCardAccount.png", nil],
                        [NSArray arrayWithObjects:@"Update Profile", @"UpdateProfileLogo.png", nil],
                        [NSArray arrayWithObjects:@"Pin Management", @"PinManagement.png", nil],
                        [NSArray arrayWithObjects:@"Transactions", @"TransactionsLogo.png", nil],
                        nil];
   
    _tableActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    //self.activityIndicatorView = activity;
    // make the area larger
    _tableActivityIndicator.hidesWhenStopped = YES;
    [_tableActivityIndicator setFrame:self.view.frame];
     // set a background color
     [_tableActivityIndicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
     CGPoint center = self.view.center;
     _tableActivityIndicator.center = center;
    [self.view addSubview:_tableActivityIndicator];
    self.navigationItem.title=@"Prepaid Account Center";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    
    
    [[SingletonGeneric UserCardInfo] RetriveUserCardInfo:@"Shobhit"];
    self.pageCardInformation = [[SingletonGeneric UserCardInfo] UserCardInformation];
    // setting the selected Card to 0 by Default
    [[SingletonGeneric UserCardInfo]SetSelectedCardInfo:0];
    
    NSInteger pageCount = self.pageCardInformation.count;
    
    if(pageCount ==1)
    {
        [self.uiPageControlScrollCard setHidden:YES];
    }
    
    // Set up the page control
    self.uiPageControlScrollCard.currentPage = 0;
    self.uiPageControlScrollCard.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    _uiScrollCard.frame = CGRectMake(0, 5, self.view.frame.size.width, 75);
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = _uiScrollCard.frame.size;
    _uiScrollCard.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageCardInformation.count, pagesScrollViewSize.height);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_uiPageMainView deselectRowAtIndexPath:[_uiPageMainView indexPathForSelectedRow] animated:YES];
   
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dsTableViewRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ptHomeTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[_dsTableViewRows objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.imageView.image = [UIImage imageNamed:[[_dsTableViewRows objectAtIndex:indexPath.row] objectAtIndex:1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([indexPath row])
    {
        case 0:
            [self performSegueWithIdentifier:@"segMyCardAccount" sender:nil];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"segUpdateProfile" sender:nil];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"segPinManagement" sender:nil];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"segTransactions" sender:nil];
            break;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int tableHeight = _uiPageMainView.bounds.size.height;
    int itemCount = [_dsTableViewRows count];
    return ((tableHeight/itemCount) -10);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:
(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.textLabel.minimumScaleFactor = 0.6;
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.uiScrollCard.frame.size.width;
    NSInteger page = (NSInteger)floor((self.uiScrollCard.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.uiPageControlScrollCard.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageCardInformation.count; i++) {
        [self purgePage:i];
    }
}
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageCardInformation.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    //_uiScrollCard.translatesAutoresizingMaskIntoConstraints = NO;
  //  NSLog(@"%@", NSStringFromCGRect(_uiScrollCard.frame));
    // Load an individual page, first checking if you've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.uiScrollCard.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        PAC_ScrollCardView *newPageView = [[PAC_ScrollCardView alloc] init];
        CardInfo *cinfo = [self.pageCardInformation objectAtIndex:page];
        [newPageView PopulateScrollCardView:cinfo];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.uiScrollCard addSubview:newPageView];
        
   
    }
}
- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageCardInformation.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self ResetScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        
        [self ResetScrollView];
        
    }
}

- (void) ResetScrollView
{
    
    CGFloat pageWidth = self.uiScrollCard.bounds.size.width;
    int page = floor((self.uiScrollCard.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.uiPageControlScrollCard.currentPage = page;
    CGRect frame = self.uiScrollCard.frame;
    frame.origin.x = frame.size.width * (self.uiPageControlScrollCard.currentPage);
    frame.origin.y = 0;
    [self.uiScrollCard scrollRectToVisible:frame animated:YES];
    [[SingletonGeneric UserCardInfo] SetSelectedCardInfo:page];
    if (page != CurrentScrollViewPage){
//    [UITableView animateWithDuration:500 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [_tableActivityIndicator startAnimating];
//    } completion:^(BOOL finished) {
//        [_tableActivityIndicator stopAnimating];    }];
        [_tableActivityIndicator startAnimating];
       // [self.view performSelector:@selector(stopTableViewAnimation) withObject:nil afterDelay:5.0];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target: self
                                                          selector: @selector(stopTableViewAnimation) userInfo: nil repeats: NO];

    }
    
    CurrentScrollViewPage = page;
}

-(void) stopTableViewAnimation
{
    [_tableActivityIndicator stopAnimating];
}
-(IBAction)contactUSButtonClicked:(id)sender {
    [self presentViewController:[[ContactUs alloc] init] animated:YES completion:nil];
}

-(void)termsButtonClicked:(id)sender {
    [self presentViewController:[[Terms alloc] init] animated:YES completion:nil];
}

-(void)faqButtonClicked:(id)sender {
    [self presentViewController:[[Faq alloc] init] animated:YES completion:nil];
}


@end
