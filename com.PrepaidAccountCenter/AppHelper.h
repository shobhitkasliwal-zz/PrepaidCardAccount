//
//  AppHelper.h
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/5/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
@interface AppHelper : NSObject
+ (NSData*)TripleDES:(NSData*)plainData encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key ;
@end
