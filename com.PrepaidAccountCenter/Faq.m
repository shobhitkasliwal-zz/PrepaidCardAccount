//
//  Faq.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "Faq.h"
#import "UIColor+Hex.h"
#import "SingletonGeneric.h"
#import "FaqAnswer.h"
#import "AppConstants.h"
#import "SVProgressHUD.h"

@interface Faq ()
@property (nonatomic, strong)NSMutableArray *dsFAQ;
@end
CardInfo *cInfo;

@implementation Faq

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
    // Do any additional setup after loading the view from its nib.
    cInfo  =  [[SingletonGeneric UserCardInfo] SelectedCard];
   
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: ", cInfo.cardNumber ];
    [_lblHeaderCard setText:cardNumbertxt];
    
    _uiHeader.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _uiHeader.layer.cornerRadius = 8; // if you like rounded corners
    _uiHeader.layer.shadowOffset = CGSizeMake(-15, 20);
    _uiHeader.layer.shadowRadius = 5;
    _uiHeader.layer.shadowOpacity = 0.5;
    [SVProgressHUD showWithStatus:@"Retriving Faq's"];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [_tblFaq setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIEdgeInsets inset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _tblFaq.contentInset = inset;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    }

    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    networkRequest.currentCallType = [NSMutableString stringWithString:@"CreateCredentialCall"];
    [networkRequest makeWebCall:[NSString stringWithFormat:FAQ_SERVICE_URL, cInfo.SiteConfigID] httpMethod:RTHTTPMethodGET];
    
   
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

-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    if (responseArray != nil) {
        _dsFAQ = responseArray;
        [_tblFaq reloadData];
    }}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_dsFAQ != nil){
    return ( _dsFAQ.count);
    }
    else{
        return 0;
    }
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FaqCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [[_dsFAQ objectAtIndex:indexPath.row] objectForKey:@"Question"];
    cell.textLabel.font = [UIFont systemFontOfSize:10.0];
    //cell.imageView.image = [UIImage imageNamed:[[_dsTableViewRows objectAtIndex:indexPath.row] objectAtIndex:1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"FaqAnswer" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FaqAnswer"])
    {
        FaqAnswer *View = [segue destinationViewController];
        NSIndexPath *index = [_tblFaq indexPathForSelectedRow];
        View.Question = [[_dsFAQ objectAtIndex:index.row] objectForKey:@"Question"];
        View.Answer = [[_dsFAQ objectAtIndex:index.row] objectForKey:@"Answer"];
    }
}
- (IBAction)Home_click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)networkNotReachable{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: INTERNET_NOT_AVAILABLE_POPUP_TITLE message: INTERNET_NOT_AVAILABLE_POPUP_TEXT delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
