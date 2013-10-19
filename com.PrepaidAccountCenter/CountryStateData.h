//
//  CountryStateData.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/17/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTNetworkRequest.h"

@interface CountryStateData : NSObject 
@property (nonatomic, strong) NSMutableArray *CountryStates;
@property (nonatomic, strong) NSString *CountryName;
@property (nonatomic, strong) NSString *A2;
@property (nonatomic, strong) NSString *A3;
@property (nonatomic, strong) NSString *CountryCode;
@property (nonatomic, strong) NSString *CurrencyName;
@property (nonatomic, strong) NSString *CurrencyAlphaCode;
@property (nonatomic, strong) NSString *ZipValidationExpression;
@property (nonatomic, strong) NSString *PhoneValidationExpression;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


- (void)InsertCountries:(NSMutableArray*)responseArray;
- (void)InsertStates:(NSMutableArray*)responseArray;
-(NSMutableArray*)getAllRecords:(NSString*) entityDescription;


@end
