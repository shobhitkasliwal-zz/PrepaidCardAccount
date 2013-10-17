//
//  CountryStateData.m
//  com.PrepaidAccountCenter
//
//  Created by Shobhit Kasliwal on 10/17/13.
//  Copyright (c) 2013 Liventus. All rights reserved.
//

#import "CountryStateData.h"
#import "Country.h"
#import "State.h"
#import "PACAppDelegate.h"
#import "RTNetworkRequest.h"
#import "AppHelper.h"

@implementation CountryStateData

-(void) InsertCountries {
    
    
    RTNetworkRequest* networkRequest = [[RTNetworkRequest alloc] initWithDelegate:self];
    [networkRequest makeWebCall:COUNTRY_LIST_SERVICE httpMethod:RTHTTPMethodGET];
    
}
-(void) serviceCallCompletedWithError:(NSError*) error
{
    
    
}
-(void)serviceCallCompleted:(BOOL)isSuccess withData:(NSMutableData *)respData currentCallType:(NSMutableString *)currentCallType
{
    NSMutableArray* responseArray = [NSJSONSerialization JSONObjectWithData:respData options:0 error:nil];
    
    if (responseArray != nil) {
        
        PACAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
        for (NSDictionary* dict in responseArray){
            
            Country * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Country"
                                                               inManagedObjectContext:self.managedObjectContext];
            
            if(![AppHelper isNullObject:[dict objectForKey:@"Country"]])
                newEntry.country = [dict objectForKey:@"Country"];
            if(![AppHelper isNullObject:[dict objectForKey:@"A2"]])
                newEntry.a2 = [dict objectForKey:@"A2"];
            if(![AppHelper isNullObject:[dict objectForKey:@"A3"]])
                newEntry.a3 = [dict objectForKey:@"A3"];
            if(![AppHelper isNullObject:[dict objectForKey:@"CountryCode"]])
                newEntry.countrycode = [dict objectForKey:@"CountryCode"];
            if(![AppHelper isNullObject:[dict objectForKey:@"CurrencyAlphaCode"]])
                newEntry.currencyalphacode = [dict objectForKey:@"CurrencyAlphaCode"];
            if(![AppHelper isNullObject:[dict objectForKey:@"CurrencyName"]])
                newEntry.currencyname = [dict objectForKey:@"CurrencyName"];
            if(![AppHelper isNullObject:[dict objectForKey:@"ZipCodeValidationExpression"]])
                newEntry.zip_validation = [dict objectForKey:@"ZipCodeValidationExpression"];
            if(![AppHelper isNullObject:[dict objectForKey:@"PhoneValidationExpression"]])
                newEntry.phone_validation = [dict objectForKey:@"PhoneValidationExpression"];
            NSError* error;
            if(![self.managedObjectContext save:&error])
            {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
}
- (void)networkNotReachable{}

-(NSMutableArray*)getAllCountries;
{
    NSArray* result = [self getAllRecords:@"Country"];
    
    }

-(void) PopulateStateCountries
{

}

-(NSArray*)getAllRecords:(NSString*) entityDescription
{
    PACAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // Returning Fetched Records
    return fetchedRecords;
}


- (void) deleteAllRecords: (NSString *) entityDescription  {
    PACAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items) {
        [self.managedObjectContext deleteObject:managedObject];
    }
}


@end
