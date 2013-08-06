//
//  NSObject+CardInfo.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/13/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "CardInfo.h"

@implementation  CardInfo




- (id)init
{
self = [super init];
    return self;
}

- (id)initWithCardNumber:(NSString *)cardNum andExpiration:(NSString *)expiration andBalance:(NSString *)balance andStatus: (NSString*) status andProxy:(NSString*)proxy andWCSClientID:(NSString*) WCSClientID
{
    
    self = [super init];
    _cardNumber = cardNum;
    _cardBalance = balance;
    _cardExpiration = expiration;
    _cardStatus = status;
    _cardProxy = proxy;
    _WcsClientID = WCSClientID;
    return self;
}



@end
