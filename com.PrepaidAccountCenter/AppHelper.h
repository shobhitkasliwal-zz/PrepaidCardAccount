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
+ (UIImage *)create3DImageWithText:(NSString *)_text Font:(UIFont*)_font ForegroundColor:(UIColor*)_foregroundColor ShadowColor:(UIColor*)_shadowColor outlineColor:(UIColor*)_outlineColor depth:(int)_depth useShine:(BOOL)_shine;
+ (NSString *) DeviceType;
+ (BOOL) isEmptyString:(NSString *) Data;
+ (void)applyShinyBackgroundWithColor:(UIColor *)color  ForView:(UIView*) myView;
+ (BOOL) isNullObject: (NSObject *) obj;
@end
