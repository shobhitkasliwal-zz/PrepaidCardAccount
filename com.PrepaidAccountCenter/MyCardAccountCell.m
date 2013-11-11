//
//  MyCardAccountCell.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/5/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "MyCardAccountCell.h"
#import "CardInfo.h"
#import "UIColor+Hex.h"
#import "AppHelper.h"
@implementation MyCardAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        //self.layer.cornerRadius = 8; // if you like rounded corners
        //self.layer.shadowOffset = CGSizeMake(-15, 20);
        //self.layer.shadowRadius = 5;
        //self.layer.shadowOpacity = 0.5;
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) populateCell:(CardInfo*) cardInfo
{
    if([AppHelper isNullObject:cardInfo.cardNumber])
        return ;
    
    [_lblMCA_CardNumber setText: cardInfo.cardNumber];
    [_lblMCA_ExpDate setText:cardInfo.cardExpiration];
    [_lblMCA_CardType setText:@"VISA"];
    NSShadow *textShadow = [[NSShadow alloc] init];
    textShadow.shadowColor = [UIColor darkGrayColor];
    textShadow.shadowBlurRadius = 3.0;
    textShadow.shadowOffset = CGSizeMake(5,5);
    NSMutableAttributedString *CardBal = [[NSMutableAttributedString alloc] initWithString:@"Balance :"];
    NSMutableAttributedString *second = [[NSMutableAttributedString alloc] initWithString:[[@" " stringByAppendingString:cardInfo.CardCurrency] stringByAppendingString:@ " "]];
    [second addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range: NSMakeRange(0,second.length)];
    [second addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, second.length)];
    _enableBalanceLink = NO;
    NSMutableAttributedString *third = nil;
    if( [cardInfo.cardBalance doubleValue] < 0 )
    {
        third =[[NSMutableAttributedString alloc] initWithString:[[@"(" stringByAppendingString:cardInfo.cardBalance] stringByAppendingString:@")"]];
        [third addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,third.length)];
    }
    else
    {
        third =[[NSMutableAttributedString alloc] initWithString:cardInfo.cardBalance];
        [third addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,third.length)];
    }
    [third addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, third.length)];
    
    [CardBal appendAttributedString:second];
    [CardBal appendAttributedString:third];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor purpleColor],
                                 NSBackgroundColorAttributeName: [UIColor clearColor],
                                 NSUnderlineStyleAttributeName: @1,
                                 NSShadowAttributeName: textShadow
                                 };
    if(!cardInfo.CIPPassed)
    {
        [_lblMCACardStatus setText:@"Identity Validation Required"];
        [_lblMCACardStatus setTextColor:[UIColor redColor]];
        NSAttributedString *myString = [[NSAttributedString alloc] initWithString:@"Details" attributes:attributes];
        _lblMCA_CardBalance.attributedText = myString;
        [_lblMCA_CardBalance setTextColor:[UIColor colorWithHexString:@"035424"]];
        _enableBalanceLink = YES;
    }
    else if(cardInfo.UserRegistrationRequired)
    {
        [_lblMCACardStatus setText:cardInfo.cardStatus];
        [_lblMCACardStatus setTextColor:[UIColor orangeColor]];
        NSAttributedString *myString = [[NSAttributedString alloc] initWithString:@"Register" attributes:attributes];
        _lblMCA_CardBalance.attributedText = myString;
        [_lblMCA_CardBalance setTextColor:[UIColor colorWithHexString:@"035424"]];
        _enableBalanceLink = YES;
    }
    else if(cardInfo.UserSecondaryAuthRequired)
    {
        [_lblMCACardStatus setText:@"Authentication Required"];
        [_lblMCACardStatus setTextColor:[UIColor orangeColor]];
        NSAttributedString *myString = [[NSAttributedString alloc] initWithString:@"Authenticate" attributes:attributes];
        _lblMCA_CardBalance.attributedText = myString;
        [_lblMCA_CardBalance setTextColor:[UIColor colorWithHexString:@"035424"]];
        _enableBalanceLink = YES;
    }
    else if([cardInfo.cardStatus caseInsensitiveCompare:@"Closed"] == NSOrderedSame)
    {
        [_lblMCACardStatus setText:@"Closed"];
        [_lblMCACardStatus setTextColor:[UIColor redColor]];
        [_lblMCA_CardBalance setAttributedText:CardBal];
    }
    else if ([cardInfo.cardStatus caseInsensitiveCompare:@"Ready"] == NSOrderedSame)
    {
        [_lblMCACardStatus setText:@"InActive"];
        [_lblMCACardStatus setTextColor:[UIColor colorWithHexString:@"035424"]];
        
        NSAttributedString *myString = [[NSAttributedString alloc] initWithString:@"Activate" attributes:attributes];
        _lblMCA_CardBalance.attributedText = myString;
        [_lblMCA_CardBalance setTextColor:[UIColor colorWithHexString:@"035424"]];
        _enableBalanceLink = YES;
    }
    else
    {
        [_lblMCACardStatus setText:cardInfo.cardStatus];
        [_lblMCACardStatus setTextColor:[UIColor colorWithHexString:@"035424"]];
        [_lblMCA_CardBalance setAttributedText:CardBal];
    }
    
    
}


@end
