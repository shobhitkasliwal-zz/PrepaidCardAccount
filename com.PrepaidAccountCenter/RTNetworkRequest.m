//
//  RTNetworkRequest.m
//
//  Created by Rishabh Tayal on 4/9/12.
//

#import "RTNetworkRequest.h"

@interface RTNetworkRequest()
{
   
}

@end

@implementation RTNetworkRequest

@synthesize responseData;
@synthesize connection;
@synthesize delegate = _delegate;
@synthesize currentCallType;

#pragma mark -

- (id)initWithDelegate:(id<RTNetworkRequestDelegate>)delegate
{
    self = [super init];
    if  (self)
    {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - POST Methods

+ (void)makeBlockWebCall:(NSString*)url completion:(void (^) (NSData* data))completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLResponse* urlResponse = nil;
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    completion(responseData);
}

- (void)makeWebCall:(NSString*)url httpMethod:(RTHTTPMethod)method 
{
//    if (![self isReachable]) {
//        [_delegate networkNotReachable];
//    }
//    else
//    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // construct request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        
        switch (method) {
            case RTHTTPMethodGET:
                [request setHTTPMethod:@"Get"];
                break;
                case RTHTTPMethodPOST:
                [request setHTTPMethod:@"Post"];
            default:
                break;
        }
        
        // fire away
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection)
        {
            responseData = [[NSMutableData alloc] initWithLength:0];
        }
        else
            NSLog(@"NSURLConnection initWithRequest: Failed to return a connection.");
//    }
}

#pragma mark - Connection Delegate
     
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    //[self.responseData setLength:0];
    NSLog(@"%@",response);
    
}
     
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    self.connection = nil;
    self.responseData = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.delegate serviceCallCompletedWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
    
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

//-(BOOL)isReachable
//{
//    Reachability *reachCheckNet = [Reachability reachabilityForInternetConnection];
//    Reachability *reachCheckWifi = [Reachability reachabilityForLocalWiFi];
//    [reachCheckNet startNotifier];
//    [reachCheckWifi startNotifier];
//    NetworkStatus netStatus = [reachCheckNet currentReachabilityStatus];
//    NetworkStatus wifiStatus = [reachCheckWifi currentReachabilityStatus];
//    if((NotReachable == netStatus) && (NotReachable == wifiStatus))
//    {
//        return NO;
//    }
//    return YES;
//}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (_delegate)
        [self.delegate serviceCallCompleted:YES withData:responseData currentCallType:(NSMutableString*)currentCallType];
}

@end   
