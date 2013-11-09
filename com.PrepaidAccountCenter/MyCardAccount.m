//
//  MyCardAccount.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "MyCardAccount.h"
#import "UIColor+Hex.h"
#import "SingletonGeneric.h"
#import "AppConstants.h"
#import "MyCardAccountCell.h"
#import "CardActionDetail.h"
#import "SVProgressHUD.h"

#define REMOVE_CARD_POPUP 1
@interface MyCardAccount ()
@property (nonatomic, strong) NSMutableArray *dsUserCards;
@end
CardActionDetail* cardDetailPopup;
CardInfo* RemoveCard_Cinfo;
@implementation MyCardAccount

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
    self.navigationItem.title = @"My Card Account";
    [_btnByBalance useBlackStyle];
    [_btnByExpiry useBlackStyle];
    [_btnByStatus useBlackStyle];
    //  [appHelper applyShinyBackgroundWithColor:[UIColor redColor] forView:self.view];
    
    [_tblCards registerNib:[UINib nibWithNibName:@"MyCardAccountCell"
                                          bundle:[NSBundle mainBundle]]
    forCellReuseIdentifier:@"CustomCellReuseID"];
    
    [_btnAddNewCard useBlackStyle];
    _dsUserCards =[[SingletonGeneric UserCardInfo] UserCardInformation];
    
    NSString* LoginByOption = [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_SELECTED_LOGIN_OPTION];
    if ([LoginByOption isEqualToString:LOGGEDIN_OPTION_CARD])
    {
        [_btnAddNewCard setHidden:YES];
        _constraintTopTableView.constant = 10;
    }else{
        [_btnAddNewCard setHidden:NO];
        _constraintTopTableView.constant = 45;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [_tblCards setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIEdgeInsets inset = UIEdgeInsetsMake(-20, 0, 0, 0);
        _tblCards.contentInset = inset;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    }
    
    cardDetailPopup = [[CardActionDetail alloc]initWithNibName:@"CardActionDetail" bundle:nil];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutClick:(id)sender {
    [self performSegueWithIdentifier:@"MyCardAccountLogout" sender:nil];
}


- (IBAction)btnByExpiry_click:(id)sender {
}

- (IBAction)btnByBalance_click:(id)sender {
}

- (IBAction)btnByStatus_click:(id)sender {
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ( _dsUserCards.count);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 75;
}

// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCellReuseID";
    MyCardAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCardAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(_dsUserCards.count > indexPath.row)
    {
        CardInfo *cinfo =  [_dsUserCards objectAtIndex:[indexPath row]];
        if (cinfo != nil){
            [cell populateCell:cinfo];
            if(cell.enableBalanceLink)
            {
                cell.lblMCA_CardBalance.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGesture =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowCardDetailPopup:)] ;
                cell.lblMCA_CardBalance.tag = indexPath.row;
                [cell.lblMCA_CardBalance addGestureRecognizer:tapGesture];
            }else
            {
                cell.lblMCA_CardBalance.userInteractionEnabled  = false;
            }
            
        }
    }
    UIView *cellSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 ,1)];
    [cellSeparator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleWidth];
    [cellSeparator setContentMode:UIViewContentModeTopLeft];
    [cellSeparator setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:cellSeparator];
    return cell;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    //  if (self.editing)
    //{
    //  return UITableViewCellEditingStyleDelete;
    // }
    NSString* LoginByOption = [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_SELECTED_LOGIN_OPTION];
    if ([LoginByOption isEqualToString:LOGGEDIN_OPTION_CARD])
    {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return @"Remove Card";
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RemoveCard_Cinfo = [[SingletonGeneric UserCardInfo].UserCardInformation objectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [NSString stringWithFormat:@"Are you sure, you want to remove %@ from your account ?",RemoveCard_Cinfo.cardNumber] delegate: self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
        alert.tag = REMOVE_CARD_POPUP;
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == REMOVE_CARD_POPUP)
    { if (buttonIndex == 0){
        [SVProgressHUD showWithStatus:@"Removing card..."];
        RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
        networkRequest.currentCallType = [NSMutableString stringWithString:@"RemoveCard"];
        NSString* Username =  [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_USERNAME];
        [networkRequest makeWebCall:[NSString stringWithFormat:REMOVE_CARD_SERVICE,RemoveCard_Cinfo.cardProxy, Username] httpMethod:RTHTTPMethodGET];
        
    }else if (buttonIndex == 1){
        //reset clicked
        [_tblCards setEditing:false animated:true];
        
    }
    }
}

-(void) serviceCallCompletedWithError:(NSError*) error
{
    
    [SVProgressHUD dismiss];
    NSString* str = [NSString stringWithFormat:@"An error occured while making the API call.\n Please contact customer support for more details."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: str delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    [SVProgressHUD dismiss];
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    if ([currentCallType isEqualToString:@"RemoveCard"])
    {
        if (responseArray != nil) {
            for (NSDictionary* dict in responseArray){
                if([dict objectForKey:@"MESSAGE"])
                {
                    
                    if ([[[dict objectForKey:@"MESSAGE"] uppercaseString] isEqualToString:@"SUCCESS"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message:@"Card Removed Successfully !!!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        
                        [[SingletonGeneric UserCardInfo] setSelectedCard:nil];
                        [[[SingletonGeneric UserCardInfo] UserCardInformation] removeObject:RemoveCard_Cinfo];
                        [_tblCards reloadData];
                    }
                    else
                    {UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: [dict objectForKey:@"MESSAGE"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"There is an error occured while removing the card.\n Please try again later." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Message" message: @"There is an error occured while removing the card.\n Please try again later." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }
}


- (void)networkNotReachable{}

-(IBAction) ShowCardDetailPopup:(UITapGestureRecognizer *)gestureRecognizer
{
    // You can also present a UIViewController with complex views in it
    // and optionally containing an explicit dismiss button for semi modal
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        UILabel* label = (UILabel*)[gestureRecognizer view];
        CardInfo *cinfo =  [_dsUserCards objectAtIndex:label.tag];
        
        cardDetailPopup.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 260);
        [self presentSemiViewController:cardDetailPopup withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                      KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
        [cardDetailPopup setupPopup:cinfo ForType:nil];
        [self presentSemiViewController:cardDetailPopup];
        
    }
}

@end
