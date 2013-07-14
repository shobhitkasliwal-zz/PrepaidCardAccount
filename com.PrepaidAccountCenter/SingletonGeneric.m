//
//  SingletonCardInfo.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "SingletonGeneric.h"
#import "CardInfo.h"

@implementation SingletonGeneric

+(SingletonGeneric*) UserCardInfo
{
    static SingletonGeneric *userCardInfo = nil;
    if(!userCardInfo)
    {
        userCardInfo = [[super allocWithZone:nil] init];
        
    }
    return userCardInfo;
}

+(id) allocWithZone:(NSZone *)zone
{
    return [self UserCardInfo];
}

- (id)init
{
    self = [super init];
    return self;
}

-(void)RetriveUserCardInfo:(NSString*)userName
{
/// We will do API call to Retrive this Information 
    _UserCardInformation= [NSArray arrayWithObjects:
     [[CardInfo alloc] initWithCardNumber:@"12345678912345" andExpiration:@"03/2016" andBalance:@"220.00"  andStatus:@"Active"],
     [[CardInfo alloc] initWithCardNumber:@"4132456309876543" andExpiration:@"05/2015" andBalance:@"70.00" andStatus:@"Ready"],
     [[CardInfo alloc] initWithCardNumber:@"4563765498743256" andExpiration:@"04/2014" andBalance:@"120.00" andStatus:@"Active"],
     [[CardInfo alloc] initWithCardNumber:@"4563765498743256" andExpiration:@"04/2014" andBalance:@"120.00" andStatus:@"Active"],
     
     nil];

}

-(void)SetSelectedCardInfo:(int) index
{
    _SelectedCard=  [_UserCardInformation objectAtIndex:index];

}

@end
