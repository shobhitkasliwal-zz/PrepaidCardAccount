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

- (id) initWithDictionary: (NSDictionary *) dict
{
    _cardNumber =  [dict objectForKey:@"CardNumber"];
    _cardExpiration  = [dict objectForKey:@"CardExpiration"];
    _cardBalance = [dict objectForKey:@"CardBalance"];
    _cardStatus =  [dict objectForKey:@"CardStatus"];
    _cardProxy =[dict objectForKey:@"CardProxy"];
    _WcsClientID = [dict objectForKey:@"WCSClientId"];
    _SiteConfigID = [dict objectForKey:@"SiteConfigID"];
    _ChangePinAllowed = [[dict objectForKey:@"ChangePinAllowed"] boolValue];
    _ViewPinOnly = [[dict objectForKey:@"ViewPinOnly"] boolValue];
    _ViewChangePinMessage = [[dict objectForKey:@"ViewPinChangeMessage"] boolValue];
    _Sec_Auth_Label=[dict objectForKey:@"Sec_Auth_Label"];
    _isUserRegistered = [[dict objectForKey:@"isUserRegistered"] boolValue];
    _UserSecondaryAuthRequired=[[dict objectForKey:@"UserSecondaryAuthRequired"] boolValue];
    return self;
}



@end
