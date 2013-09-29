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
#import "MyCardAccountsCell.h"
#import "AppConstants.h"
@interface MyCardAccount ()
@property (nonatomic, strong) NSMutableArray *dsUserCards;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
      self.navigationItem.title = @"My Card Account";
  //  [appHelper applyShinyBackgroundWithColor:[UIColor redColor] forView:self.view];
   
    [_btnAddNewCard useBlackStyle];
    _dsUserCards =[[SingletonGeneric UserCardInfo] UserCardInformation];

    NSString* LoginByOption = [[[SingletonGeneric UserCardInfo] UserCredenitalInfo] objectForKey:LOGGEDIN_CREDENTIAL_KEY_SELECTED_LOGIN_OPTION];
    if ([LoginByOption isEqualToString:LOGGEDIN_OPTION_CARD])
    {
        [_btnAddNewCard setHidden:YES];
    }else{
        [_btnAddNewCard setHidden:NO];
    }
    
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


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MCACell";
    MyCardAccountsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCardAccountsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(_dsUserCards.count > indexPath.row)
    {
        CardInfo *cinfo =  [_dsUserCards objectAtIndex:[indexPath row]];
        if (cinfo != nil){
            [cell.lblMCA_CardNumber setText: cinfo.cardNumber];
            
            //  cell.contentView.backgroundColor = [UIColor colorWithRed:99/255.f green:184/255.f blue:255/255.f alpha:1];
        }
    }
    return cell;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove Card";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        //[dataSourceArray removeObjectAtIndex:indexPath.row];
    }    
}
@end
