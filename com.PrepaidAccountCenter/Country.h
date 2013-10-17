//
//  Country.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/17/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * a2;
@property (nonatomic, retain) NSString * a3;
@property (nonatomic, retain) NSString * countrycode;
@property (nonatomic, retain) NSString * currencyname;
@property (nonatomic, retain) NSString * currencyalphacode;
@property (nonatomic, retain) NSString * zip_validation;
@property (nonatomic, retain) NSString * phone_validation;

@end
