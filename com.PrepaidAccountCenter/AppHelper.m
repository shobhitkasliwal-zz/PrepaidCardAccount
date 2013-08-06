//
//  AppHelper.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 8/5/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "AppHelper.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
@implementation AppHelper


+ (NSData*)TripleDES:(NSData*)plainData encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:plainData];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        plainTextBufferSize = [plainData length];
        vplainText = (const void *)[plainData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    else if (ccStatus == kCCParamError) NSLog( @"PARAM ERROR");
    else if (ccStatus == kCCBufferTooSmall) NSLog( @"BUFFER TOO SMALL");
    else if (ccStatus == kCCMemoryFailure) NSLog( @"MEMORY FAILURE");
    else if (ccStatus == kCCAlignmentError) NSLog( @"ALIGNMENT");
    else if (ccStatus == kCCDecodeError) NSLog( @"DECODE ERROR");
    else if (ccStatus == kCCUnimplemented) NSLog( @"UNIMPLEMENTED");
    
    NSData *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 encodeData:myData];
    }
    
    return result;
}


@end
