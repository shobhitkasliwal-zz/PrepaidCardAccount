//
//  RTNetworkRequest.h
//
//  Created by Rishabh Tayal on 10/1/12.
//  Copyright (c) 2012 Rishabh Tayal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    RTHTTPMethodGET = 0,
    RTHTTPMethodPOST
}RTHTTPMethod;

@protocol RTNetworkRequestDelegate;

@interface RTNetworkRequest : NSObject

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *responseData;
@property(nonatomic, strong) id <RTNetworkRequestDelegate> delegate;
 @property(nonatomic, strong)  NSMutableString *currentCallType;

- (id)initWithDelegate:(id<RTNetworkRequestDelegate>)delegate;



- (void)makeWebCall:(NSString*)url httpMethod:(RTHTTPMethod)method;
+ (void)makeBlockWebCall:(NSString*)url completion:(void (^) (NSData* data))completion;

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;


@end

@protocol RTNetworkRequestDelegate <NSObject>

-(void)serviceCallCompletedWithError: (NSError *) error;
@required

- (void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString*)currentCallType;
- (void)networkNotReachable;

@end
