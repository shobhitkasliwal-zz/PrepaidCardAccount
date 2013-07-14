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
    _uiScrollCardView.layer.masksToBounds =YES;
    _uiScrollCardView.layer.cornerRadius =12;
    
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
    [_lblCardNumber setText: card.cardNumber];
    [_lblCardBalance setText: card.cardBalance];
    [_lblCardExpiration setText: card.cardExpiration];
    self.layer.cornerRadius = 12;
}

@end
