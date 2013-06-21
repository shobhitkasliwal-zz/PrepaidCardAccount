//
//  PAC_LoggedIn_HomeViewController.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 6/11/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "PAC_LoggedIn_HomeViewController.h"
#import "PACLoggedinHome_CustomTableCell.h"

@interface PAC_LoggedIn_HomeViewController ()

@end

@implementation PAC_LoggedIn_HomeViewController

NSArray *tabledata;

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
    tabledata = [[NSArray alloc] initWithObjects:@"My Card Accounts",@"Update Profile", @"PIN Management",@"Transactions", nil];
   
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
    
    return (sizeof tabledata);
    
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    
    
    PACLoggedinHome_CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[PACLoggedinHome_CustomTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    
cell.CellTitle.text = [tabledata objectAtIndex: [indexPath row]];
    
    // Set up the cell...
    
//    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
//    
//    cell.textLabel.text = [tabledata objectAtIndex: [indexPath row]];
   cell.contentView.backgroundColor = [UIColor blueColor];
    cell.CellTitle.backgroundColor = [UIColor blueColor];
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
