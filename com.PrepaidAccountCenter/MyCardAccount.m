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
@property (nonatomic, strong) NSMutableArray *items;
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

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        [_items addObject:@(i)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _carousel.type = iCarouselTypeInvertedWheel;
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

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_items count];
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    NSString* str = [NSString stringWithFormat:@"Item Index:%d",[carousel currentItemIndex]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
      //  view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        //((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view = [[[NSBundle mainBundle] loadNibNamed:@"MyCardAccountSubView" owner:self options:nil] lastObject];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [_items[index] stringValue];
    
    return view;
}
@end
