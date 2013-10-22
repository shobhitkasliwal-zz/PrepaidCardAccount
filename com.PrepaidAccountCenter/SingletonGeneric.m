//
//  SingletonCardInfo.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/14/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "SingletonGeneric.h"
#import "CardInfo.h"
#import "AppHelper.h"

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
    _UserCredenitalInfo = [[NSMutableDictionary alloc] init];
    return self;
}

-(void)RetriveUserCardInfo:(NSString*)userName 
{
/// We will do API call to Retrive this Information 
    _UserCardInformation= [NSMutableArray arrayWithObjects:
     [[CardInfo alloc] initWithCardNumber:@"4842240009258985" andExpiration:@"03/2016" andBalance:@"220.00"  andStatus:@"Active" andProxy:@"0436581751987" andWCSClientID:@"100733"],
     [[CardInfo alloc] initWithCardNumber:@"4195030380045025" andExpiration:@"05/2015" andBalance:@"70.00" andStatus:@"Ready" andProxy:@"0621459673021" andWCSClientID:@"376888"],
     [[CardInfo alloc] initWithCardNumber:@"4195030380045066" andExpiration:@"04/2014" andBalance:@"120.00" andStatus:@"Active" andProxy:@"0622458565069" andWCSClientID:@"376888"],
     [[CardInfo alloc] initWithCardNumber:@"4195030380045058" andExpiration:@"04/2014" andBalance:@"120.00" andStatus:@"Active" andProxy:@"0625453894050" andWCSClientID:@"376888"],
     
     nil];

}

-(void) setAllCardInfo: (NSMutableArray*) arrCardInfo
{
    _UserCardInformation = arrCardInfo;
}

-(void) updateCardInfo:(CardInfo*) cinfo
{
    for (CardInfo* info in _UserCardInformation)
    {
    if ([info.cardProxy isEqualToString:cinfo.cardProxy])
        {
            NSInteger index = [_UserCardInformation indexOfObject:info];
            [_UserCardInformation removeObjectAtIndex:index];
            [_UserCardInformation insertObject:cinfo atIndex:index];
            break;
        }
    }
}

-(void) addCardInfo: (CardInfo*) cinfo
{
    BOOL addcard = YES;
    if ([_UserCardInformation count] == 1 )
    {
        CardInfo* ci = [_UserCardInformation objectAtIndex:0];
        if([AppHelper isNullObject:ci.cardNumber])
        {
            _UserCardInformation= [NSMutableArray arrayWithObjects: cinfo, nil];
            addcard = NO;
        }
    }
      if (addcard == YES)
      {
          [_UserCardInformation addObject:cinfo];
      }
}

-(void)SetSelectedCardInfo:(int) index
{
    _SelectedCard=  [_UserCardInformation objectAtIndex:index];

}

@end
