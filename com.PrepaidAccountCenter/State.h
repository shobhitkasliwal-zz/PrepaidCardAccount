//
//  State.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/17/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface State : NSManagedObject

@property (nonatomic, retain) NSString * countrycode;
@property (nonatomic, retain) NSString * statecode;
@property (nonatomic, retain) NSString * statename;

@end
