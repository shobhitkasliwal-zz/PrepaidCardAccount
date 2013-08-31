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


+ (UIImage *)create3DImageWithText:(NSString *)_text Font:(UIFont*)_font ForegroundColor:(UIColor*)_foregroundColor ShadowColor:(UIColor*)_shadowColor outlineColor:(UIColor*)_outlineColor depth:(int)_depth useShine:(BOOL)_shine {
    
    //calculate the size we will need for our text
    CGSize expectedSize = [_text sizeWithFont:_font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    //increase our size, as we will draw in 3d, so we need extra space for 3d depth + shadow with blur
    expectedSize.height+=_depth+5;
    expectedSize.width+=_depth+5;
    
    UIColor *_newColor;
    
    UIGraphicsBeginImageContextWithOptions(expectedSize, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //because we want to do a 3d depth effect, we are going to slightly decrease the color as we move back
    //so here we are going to create a color array that we will use with required depth levels
    NSMutableArray *_colorsArray = [[NSMutableArray alloc] initWithCapacity:_depth];
    
    CGFloat *components =  (CGFloat *)CGColorGetComponents(_foregroundColor.CGColor);
    
    //add as a first color in our array the original color
    [_colorsArray insertObject:_foregroundColor atIndex:0];
    
    //create a gradient of our color (darkening in the depth)
    int _colorStepSize = floor(100/_depth);
    
    for (int i=0; i<_depth; i++) {
        
        for (int k=0; k<3; k++) {
            if (components[k]>(_colorStepSize/255.f)) {
                components[k]-=(_colorStepSize/255.f);
            }
        }
        _newColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:CGColorGetAlpha(_foregroundColor.CGColor)];
        
        //we are inserting always at first index as we want this array of colors to be reversed (darkest color being the last)
        [_colorsArray insertObject:_newColor atIndex:0];
    }
    
    //we will draw repeated copies of our text, with the outline color and foreground color, starting from the deepest
    for (int i=0; i<_depth; i++) {
        
        //change color
        _newColor = (UIColor*)[_colorsArray objectAtIndex:i];
        
        //draw the text
        CGContextSaveGState(context);
        
        CGContextSetShouldAntialias(context, YES);
        
        //draw outline if this is the last layer (front one)
        if (i+1==_depth) {
            CGContextSetLineWidth(context, 1);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            
            CGContextSetTextDrawingMode(context, kCGTextStroke);
            [_outlineColor set];
            [_text drawAtPoint:CGPointMake(i, i) withFont:_font];
        }
        
        //draw filling
        [_newColor set];
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        //if this is the last layer (first one we draw), add the drop shadow too and the outline
        if (i==0) {
            CGContextSetShadowWithColor(context, CGSizeMake(-2, -2), 4.0f, _shadowColor.CGColor);
        }
        else if (i+1!=_depth){
            //add glow like blur
            CGContextSetShadowWithColor(context, CGSizeMake(-1, -1), 3.0f, _newColor.CGColor);
        }
        
        [_text drawAtPoint:CGPointMake(i, i) withFont:_font];
        CGContextRestoreGState(context);
    }
    
    //if we need to apply the shine
    if (_shine) {
        //create an alpha mask from the top most layer of the image, so we can add a shine effect over it
        CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
        CGContextRef imageContext = CGBitmapContextCreate(NULL, (int)expectedSize.width, (int)expectedSize.height, 8, (int)expectedSize.width * 4, genericRGBColorspace,  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        UIGraphicsPushContext(imageContext);
        CGContextSetTextDrawingMode(imageContext, kCGTextFill);
        [_text drawAtPoint:CGPointMake(_depth-1, _depth-1) withFont:_font];
        CGImageRef alphaMask = CGBitmapContextCreateImage(imageContext);
        CGContextRelease(imageContext);
        UIGraphicsPopContext();
        
        //draw shine effect
        //clip context to the mask we created
        CGRect drawRect = CGRectZero;
        drawRect.size = expectedSize;
        CGContextSaveGState(context);
        CGContextClipToMask(context, drawRect, alphaMask);
        
        CGContextSetBlendMode(context, kCGBlendModeLuminosity);
        
        size_t num_locations = 4;
        CGFloat locations[4] = { 0.0, 0.4, 0.6, 1};
        CGFloat gradientComponents[16] = {
            0.0, 0.0, 0.0, 1.0,
            0.6, 0.6, 0.6, 1.0,
            0.8, 0.8, 0.8, 1.0,
            0.0, 0.0, 0.0, 1.0
        };
        
        CGGradientRef glossGradient = CGGradientCreateWithColorComponents(genericRGBColorspace, gradientComponents, locations, num_locations);
        CGPoint start = CGPointMake(0, 0);
        CGPoint end = CGPointMake(0, expectedSize.height);
        CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
        
        CGColorSpaceRelease(genericRGBColorspace);
        CGGradientRelease(glossGradient);
        CGImageRelease(alphaMask);
        CGContextRestoreGState(context);
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

+(NSString *) DeviceType
{
    NSString* deviceType = [UIDevice currentDevice].model;
    if ([[deviceType lowercaseString] rangeOfString:@"iphone"].location != NSNotFound) {
       return @"iphone";
    } else {
        return @"ipad";
    }
    
}

@end
