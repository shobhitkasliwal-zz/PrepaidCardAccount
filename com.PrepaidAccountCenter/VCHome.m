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

@interface VCHome ()
@property (nonatomic, strong)NSArray *dsTableViewRows;
@property (nonatomic, strong) NSMutableArray *pageCardInformation;

@property (nonatomic,strong) UIActivityIndicatorView *tableActivityIndicator;


@end
int CurrentScrollViewPage;
@implementation VCHome

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    
      self.pageCardInformation = [[SingletonGeneric UserCardInfo] UserCardInformation];
    
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
    _CardScrollView.type = iCarouselTypeCylinder;
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
    [_tableActivityIndicator setFrame:self.view.bounds];
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
    NSInteger pageCount = self.pageCardInformation.count;
    
    if(pageCount ==1)
    {
        [self.uiPageControlScrollCard setHidden:YES];
    }
    
    // Set up the page control
    self.uiPageControlScrollCard.currentPage = 0;
    self.uiPageControlScrollCard.numberOfPages = pageCount;
   
   
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_uiPageMainView deselectRowAtIndexPath:[_uiPageMainView indexPathForSelectedRow] animated:YES];
   
    //_vw_SC_View.frame = _vw_ScrollWrapper.frame;
   
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







- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_pageCardInformation count];
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
//NSString* str = [NSString stringWithFormat:@"Item Index:%d",[carousel currentItemIndex]];
 //   UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    
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
    //_vw_SC_View.translatesAutoresizingMaskIntoConstraints = NO;
    //[_vw_SC_View setFrame:CGRectMake(0, 0, _vw_ScrollWrapper.bounds.size.width, _vw_SC_View.bounds.size.height)];
 
   
    
    NSMutableString *cardNumber = [NSMutableString stringWithString:[card.cardNumber substringFromIndex:[card.cardNumber length] - 6] ];
    [cardNumber insertString:@"-" atIndex:2];
       NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"xxxx-xxxx-xx", cardNumber ];
     [_lbl_SC_CardNumber setText: cardNumbertxt];
    [_lbl_SC_Balance setText: [NSString stringWithFormat:@"%@%@", @"Balance: USD " , card.cardBalance ]];
    
    [_lbl_SC_Expiration setText:[NSString stringWithFormat:@"%@%@",@"Expiration: ", card.cardExpiration]];
    _vw_SC_View.layer.cornerRadius = 12;
    _vw_SC_View.layer.shadowOffset = CGSizeMake(-15, 20);
    _vw_SC_View.layer.shadowRadius = 5;
    _vw_SC_View.layer.shadowOpacity = 0.5;
    NSArray *colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"3F3F3F"], [UIColor colorWithHexString:@"9F9F9F"], nil];
    _vw_SC_View.colors= colors;
    
   
}

-(void) stopTableViewAnimation
{
    [_tableActivityIndicator stopAnimating];
}
- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"HomeLogout" sender:nil];
    
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
