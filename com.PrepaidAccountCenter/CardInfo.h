//
//  NSObject+CardInfo.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 7/13/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  CardInfo:NSObject
- (id)init;
- (id)initWithCardNumber:(NSString *)cardNum andExpiration:(NSString *)expiration andBalance:(NSString *)balance andStatus: (NSString*) status andProxy:(NSString*) proxy andWCSClientID:(NSString*) WCSClientID;
- (id) initWithDictionary: (NSDictionary *) dict;
@property (nonatomic, strong) NSString* cardNumber;
@property (nonatomic, strong) NSString* cardExpiration;
@property (nonatomic, strong) NSString* cardBalance;
@property (nonatomic, strong) NSString* cardStatus;
@property (nonatomic, strong) NSString* cardProxy;
@property (nonatomic, strong) NSString* WcsClientID;
@property (nonatomic, strong) NSString* SiteConfigID;
@property (nonatomic, assign) BOOL ChangePinAllowed;
@property (nonatomic, assign) BOOL ViewPinOnly;
@property (nonatomic, assign) BOOL ViewChangePinMessage;
@end
