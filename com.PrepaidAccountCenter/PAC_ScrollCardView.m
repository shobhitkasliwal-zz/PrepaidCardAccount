//
//  PAC_ScrollCardView.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/13/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "PAC_ScrollCardView.h"
#import "CardInfo.h"
#import <QuartzCore/QuartzCore.h>

@implementation PAC_ScrollCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"PAC_ScrollCardView"
                                                             owner:self
                                                           options:nil];
        UIView *_myView = [nibContents objectAtIndex:0];
        
        [self addSubview: _myView];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) PopulateScrollCardView: (CardInfo*)card
{
    
   
    NSMutableString *cardNumber = [NSMutableString stringWithString:[card.cardNumber substringFromIndex:[card.cardNumber length] - 6] ];
    [cardNumber insertString:@"-" atIndex:2];
    NSString* cardNumbertxt = [NSString stringWithFormat:@"%@%@", @"xxxx-xxxx-xx", cardNumber ];
     [_lblCardNumber setText: cardNumbertxt];
    [_lblBal setText: [NSString stringWithFormat:@"%@%@", @"Balance: USD " , card.cardBalance ]];
    
    [_lblExpiration setText:[NSString stringWithFormat:@"%@%@",@"Expiration: ", card.cardExpiration]];
    //self.layer.cornerRadius = 12;
}

@end
