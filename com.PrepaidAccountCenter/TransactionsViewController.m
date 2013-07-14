//
//  TransactionsViewController.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionsTbl_CustomCell.h"
#import "SingletonGeneric.h"
#import "CardInfo.h"

@interface TransactionsViewController ()
@property (nonatomic, strong) NSArray *tabledata;
@end

@implementation TransactionsViewController

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
     _tabledata = [[NSArray alloc] initWithObjects:@"Transaction 1",@"Transaction 2", @"Transaction 3",@"Transaction 4", @"Transaction 5",@"Transaction 6",@"Transaction 7",@"Transaction 8",@"Transaction 9",@"Transaction 10", nil];
    
   CardInfo *cInfo =  [[SingletonGeneric UserCardInfo] SelectedCard];
    [_lblCardNumber setText:cInfo.cardNumber];
    [_lblCardExpiration setText:cInfo.cardExpiration];
    [_lblCardBalance setText:cInfo.cardBalance];
    [_lblCardStatus setText:cInfo.cardStatus];
    self.navigationItem.title=@"Transactions";
    
  
   
    
}

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
    
    return 10;//(sizeof _tabledata);
    
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    
    
    TransactionsTbl_CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[TransactionsTbl_CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    
    cell.CellTitle.text = [_tabledata objectAtIndex: [indexPath row]];
    
    // Set up the cell...
    
    //    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    //
    //    cell.textLabel.text = [tabledata objectAtIndex: [indexPath row]];
    cell.contentView.backgroundColor = [UIColor colorWithRed:99/255.f green:184/255.f blue:255/255.f alpha:1];
    cell.CellTitle.backgroundColor = [UIColor clearColor];
    
    //
    //     [_tblOptions setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // open a alert with an OK and cancel button
    
    NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    [alert show];
    
    
    
}

-  (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
    
}

@end
