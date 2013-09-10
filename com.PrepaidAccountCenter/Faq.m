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
#define GetPINURL @"http://test.prepaidcardstatus.com/MobileServices/JsonService.asmx/GetCardPinInformation?Proxy=%@&WCSClientID=%@&SiteConfigID=%@"
@interface Faq ()
@property (nonatomic, strong)NSArray *dsFAQ;
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
    NSMutableString *cardNumber = [NSMutableString stringWithString:[cInfo.cardNumber substringFromIndex:[cInfo.cardNumber length] - 6] ];
    [cardNumber insertString:@"-" atIndex:2];
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"Card Account: xxxx-xxxx-xx", cardNumber ];
    [_lblHeaderCard setText:cardNumbertxt];
    
    _uiHeader.colors = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"9F9F9F"], [UIColor colorWithHexString:@"2F2F2F"], nil];
    _uiHeader.layer.cornerRadius = 8; // if you like rounded corners
    _uiHeader.layer.shadowOffset = CGSizeMake(-15, 20);
    _uiHeader.layer.shadowRadius = 5;
    _uiHeader.layer.shadowOpacity = 0.5;
    
    _dsFAQ = [NSArray arrayWithObjects:
              [NSArray arrayWithObjects:@"Where can I use my Card?", @"Your card is pre-loaded with value. If the front of your card indicates 'DOMESTIC USE ONLY' it may be used in the U.S. and District of Columbia wherever Visa debit cards are accepted. The card may not be used at any merchant, including internet and mail or telephone order merchants, outside of the U.S. or the District of Columbia. If the front of your card does not indicate 'DOMESTIC USE ONLY' it may be used wherever Visa Debit cards are accepted worldwide.", nil],
              [NSArray arrayWithObjects:@"At what type of merchants can I use my Card?", @"Physical cards may be used at physical merchant locations, online, over the phone and for mailed payments. Virtual card accounts may not be used at physical merchant locations, but may be used online, over the phone and for mailed payments.", nil],
              [NSArray arrayWithObjects:@"Does my Card expire?", @"Pay close attention to the expiration date printed on the front of the card. The card is valid through the last day of the month shown on the front of the card. You will not have access to the funds after expiration.", nil],
              [NSArray arrayWithObjects:@"Can my Card ever have a negative balance? ", @"Any authorization request that is greater than your cardís available balance will be declined. However, there can be times when a merchant completes a transaction without prior authorization. If an overdraft occurs, the cardholder will be required to make a payment to Cardholder Services to cover the negative amount.", nil],
              [NSArray arrayWithObjects:@"Do I need to activate my Card? ", @"Go to prepaidcardstatus.com to register your card in case it is lost or stolen. Your card is active and ready for use unless you are informed otherwise.", nil],
              nil];
    
    
    
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
    
    return ( _dsFAQ.count);
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FaqCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[_dsFAQ objectAtIndex:indexPath.row] objectAtIndex:0];
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
        View.Question = [[_dsFAQ objectAtIndex:index.row] objectAtIndex:0];
    View.Answer = [[_dsFAQ objectAtIndex:index.row] objectAtIndex:1];
    }
}
- (IBAction)Home_click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
