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
#import <QuartzCore/QuartzCore.h>
#import "ContactUs.h"
#import "Terms.h"
#import "Faq.h"
#import "Logout.h"
#import "UIColor+Hex.h"
#import "OBGradientView.h"
#import "SVProgressHUD.h"
#import "AppHelper.h"
#import "CardActionDetail.h"


#define NO_CARD_FOR_USERNAME_TAG 1
@interface VCHome ()
@property (nonatomic, strong)NSArray *dsTableViewRows;
@property (nonatomic, strong) NSMutableArray *pageCardInformation;

@end
int CurrentScrollViewPage;
CardActionDetail* cardDetailPopup;
@implementation VCHome

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    
    
    
}

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
    self.view.backgroundColor = [UIColor clearColor];
    _CardScrollView.type = iCarouselTypeInvertedCylinder;
    _CardScrollView.scrollSpeed = 0.2;
    CurrentScrollViewPage = -1;
    _dsTableViewRows = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"My Card Account", @"MyCardAccount.png", nil],
                        [NSArray arrayWithObjects:@"Update Profile", @"UpdateProfileLogo.png", nil],
                        [NSArray arrayWithObjects:@"Pin Management", @"PinManagement.png", nil],
                        [NSArray arrayWithObjects:@"Transactions", @"TransactionsLogo.png", nil],
                        nil];
    
    self.navigationItem.title=@"Prepaid Account Center";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    //  [AppHelper applyShinyBackgroundWithColor:[UIColor colorWithHexString:@"FFFFFF"] ForView:_vwBottomInfoBar];
    // [self.view bringSubviewToFront:_vwBottomInfoBar];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [_uiPageMainView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIEdgeInsets inset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _uiPageMainView.contentInset = inset;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    }
    
    _CardScrollView.backgroundColor = [UIColor clearColor];
    [self setupBottomBar];
    cardDetailPopup = [[CardActionDetail alloc]initWithNibName:@"CardActionDetail" bundle:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Tag:%@",[NSString stringWithFormat:@"%0.0f", (float)alertView.tag]);
    if (alertView.tag == NO_CARD_FOR_USERNAME_TAG &&   buttonIndex == 0){
        [self performSegueWithIdentifier:@"segAddCardToAccount" sender:nil];
    }else if (buttonIndex == 1){
        //reset clicked
    }
    
   
}

-(void) setupBottomBar
{
    _vwBottomInfoBar.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"8c9fb4"], [UIColor colorWithHexString:@"daeafb"], nil];
    _vwBottomInfoBar.layer.cornerRadius = 0; // if you like rounded corners
    _vwBottomInfoBar.layer.shadowOffset = CGSizeMake(-15, 20);
    _vwBottomInfoBar.layer.shadowRadius = 5;
    _vwBottomInfoBar.layer.shadowOpacity = 0.5;
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
    [viewsDictionary addEntriesFromDictionary:NSDictionaryOfVariableBindings(_btnContactUS)];
    [viewsDictionary addEntriesFromDictionary:NSDictionaryOfVariableBindings(_btnFaq)];
    [viewsDictionary addEntriesFromDictionary:NSDictionaryOfVariableBindings(_btnTerms)];
    [viewsDictionary addEntriesFromDictionary:NSDictionaryOfVariableBindings(_btnCredentials)];
    
    // create 4 spacer views
    for (int i = 0; i < 5; i++) {
        UIView *spacerView = [[UIView alloc] init];
        spacerView.hidden = YES;
        [_vwBottomInfoBar addSubview:spacerView];
        [viewsDictionary setObject:spacerView
                            forKey:[NSString stringWithFormat:@"spacer%d", i + 1]];
    }
    
    // disable translatesAutoresizingMaskIntoConstraints in views for auto layout
    [viewsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [obj setTranslatesAutoresizingMaskIntoConstraints:NO];
     }];
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:
                            @"|-[spacer1(>=0)][_btnContactUS][spacer2(==spacer1)][_btnFaq][spacer3(==spacer1)][_btnTerms][spacer4(==spacer1)][_btnCredentials][spacer5(==spacer1)]-|"
                                                                   options:kNilOptions
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [_vwBottomInfoBar addConstraints:constraints];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pageCardInformation = [[SingletonGeneric UserCardInfo] UserCardInformation];
    
    [_uiPageMainView deselectRowAtIndexPath:[_uiPageMainView indexPathForSelectedRow] animated:YES];
    
    NSMutableArray* cinfoArray  =   [[SingletonGeneric UserCardInfo] UserCardInformation];
    if ([cinfoArray count] > 0 )
    {
        CardInfo* ci = [cinfoArray objectAtIndex: 0];
        if ([AppHelper isNullObject:ci.cardNumber])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message:@"You dont have any card associated with this username.\n Please add a card first."  delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = NO_CARD_FOR_USERNAME_TAG;
            [alert show];
            
        }
        
    }
    NSInteger pageCount = self.pageCardInformation.count;
    
    if(pageCount ==1)
    {
        [self.uiPageControlScrollCard setHidden:YES];
    }
    
    // Set up the page control
    self.uiPageControlScrollCard.currentPage = 0;
    self.uiPageControlScrollCard.numberOfPages = pageCount;
    
    [_CardScrollView reloadData];
    
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
            if ([self ValidateCardForSegue: @"segUpdateProfile"]) {
                
                [self performSegueWithIdentifier:@"segUpdateProfile" sender:nil];
            }
            break;
            
        case 2:
            if ([self ValidateCardForSegue:@"segPinManagement"]) {
                
                [self performSegueWithIdentifier:@"segPinManagement" sender:nil];
                
            }break;
            
        case 3:
            if ([self ValidateCardForSegue:@"segTransactions"]) {
                
                [self performSegueWithIdentifier:@"segTransactions" sender:nil];
            }
            break;
    }
    
    
    
}

-(BOOL) ValidateCardForSegue:(NSString*) type
{
    CardInfo *  cardInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
    if(!cardInfo.CIPPassed || cardInfo.UserRegistrationRequired || cardInfo.UserSecondaryAuthRequired || [cardInfo.cardStatus caseInsensitiveCompare:@"Closed"] == NSOrderedSame || [cardInfo.cardStatus caseInsensitiveCompare:@"Ready"] == NSOrderedSame)
    {
         cardDetailPopup.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 260);
        [cardDetailPopup setupPopup:cardInfo ForType:type];
        [self presentSemiViewController:cardDetailPopup withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                      KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
        return NO;
    }
    else
    {
        return YES;
    }
    
}

- (void)semiModalDismissed:(NSNotification *) notification {
    if (notification.object == self) {
        if(cardDetailPopup.ActionSuccessful){
            if([self ValidateCardForSegue:cardDetailPopup.ActionType]){
            [self performSegueWithIdentifier:cardDetailPopup.ActionType sender:nil];
            }
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //    int tableHeight = _uiPageMainView.bounds.size.height;
    //    int itemCount = [_dsTableViewRows count];
    //    return ((tableHeight/itemCount) -10);
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:
(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.textLabel.minimumScaleFactor = 0.6;
}







- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_pageCardInformation count];
}

static float progressTableAnimate = 0.0f;

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if (CurrentScrollViewPage != -1)
    {
        if (CurrentScrollViewPage != carousel.currentItemIndex)
        {
            //[SVProgressHUD showProgress:0 status:@"Updating Data" maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD show];
            [self performSelector:@selector(dismissTableAnimateProgress) withObject:nil afterDelay:0.3];
        }
    }
    CurrentScrollViewPage = carousel.currentItemIndex;
    _uiPageControlScrollCard.currentPage = carousel.currentItemIndex;
    [[SingletonGeneric UserCardInfo] SetSelectedCardInfo:carousel.currentItemIndex];
}

- (void)increaseTableAnimateProgress {
    progressTableAnimate+=1.0f;
    [SVProgressHUD showProgress:progressTableAnimate status:@"Updating Data"];
    
    if(progressTableAnimate < 1.0f){
        [self performSelector:@selector(increaseTableAnimateProgress) withObject:nil afterDelay:0.1];}
    else{
        [self performSelector:@selector(dismissTableAnimateProgress) withObject:nil afterDelay:0.1f];
    }
}
- (void)dismissTableAnimateProgress {
	[SVProgressHUD dismiss];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //  view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        //((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view =[[[NSBundle mainBundle] loadNibNamed:@"PAC_ScrollCardView" owner:self options:nil] lastObject];
        view.contentMode = UIViewContentModeCenter;
        
        
    }
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = [_items[index] stringValue];
    CardInfo* ci = _pageCardInformation[index];
    [self PopulateScrollCardView:ci];
    
    //_vw_SC_View.frame = carousel.frame;
    //  carousel.frame = _vw_ScrollWrapper.frame;
    return view;
}

- (void) PopulateScrollCardView: (CardInfo*)card
{
    
    [_lbl_SC_CardNumber setText: card.cardNumber];
    [_lbl_SC_Balance setText: [NSString stringWithFormat:@"%@%@", @"Balance: USD " , card.cardBalance ]];
    
    [_lbl_SC_Expiration setText:[NSString stringWithFormat:@"%@%@",@"Expiration: ", card.cardExpiration]];
    _vw_SC_View.layer.cornerRadius = 12;
    _vw_SC_View.layer.shadowOffset = CGSizeMake(-15, 20);
    _vw_SC_View.layer.shadowRadius = 5;
    _vw_SC_View.layer.shadowOpacity = 0.5;
    NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"3F3F3F"], [UIColor colorWithHexString:@"9F9F9F"], nil];
    _vw_SC_View.colors= colors;
    
    
}

- (IBAction)PageChange:(id)sender {
    [ _CardScrollView scrollToItemAtIndex:_uiPageControlScrollCard.currentPage animated:YES];
    
}

- (IBAction)Credentials_click:(id)sender {
}

- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"HomeLogout" sender:nil];
    
}


-(IBAction)contactUSButtonClicked:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    //   [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self presentViewController:[[ContactUs alloc] init] animated:YES completion:nil];
}

-(void)termsButtonClicked:(id)sender {
    [self presentViewController:[[Terms alloc] init] animated:YES completion:nil];
}

-(void)faqButtonClicked:(id)sender {
    //  [self presentViewController:[[Faq alloc] init] animated:YES completion:nil];
    [self performSegueWithIdentifier:@"segFAQ" sender:nil];
    
}


@end
