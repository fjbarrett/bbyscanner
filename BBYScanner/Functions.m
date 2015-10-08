//
//  Functions.m
//  BBYScanner
//
//  Created by Frank Barrett on 6/25/15.
//  Copyright (c) 2015 Frank Barrett. All rights reserved.
//

#import "Functions.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

NSDictionary *dictionary;
NSString *storeNumber;
NSUserDefaults *defaults;

@implementation Functions

NSDictionary *storesDataDictionary;
NSDictionary *productsDataDictionary;

NSString*
machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (void) postToMysql:(NSString*)string {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *post = [NSString stringWithFormat:@"data=%@&name=%@&store=%@&model=%@&version=%@",string, [UIDevice currentDevice].name, [defaults valueForKey:@"storeNumber"], machineName(), [UIDevice currentDevice].systemVersion];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://104.236.136.56/hypnotics/algo/test1.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(string);
    } else {
        NSLog(string);
    }

}

- (NSString *) QRPopFlip:(NSString*)codeToCut {
    
    NSString *newDetectionString = codeToCut;
    NSRange range = NSMakeRange(0, 24);
    NSString *strippedCode = [newDetectionString stringByReplacingCharactersInRange:range withString:@""];
    NSLog(@"%@", strippedCode);
    return strippedCode;
}

- (NSString*) BBYCustomPopFlip:(NSString*)codeToCut {
    
    NSString *newDetectionString = codeToCut;
    NSRange range = NSMakeRange(0, 3);
    NSString *strippedCode = [newDetectionString stringByReplacingCharactersInRange:range withString:@""];
    NSLog(@"%@", strippedCode);
    NSRange secondRange = NSMakeRange(7, 6);
    strippedCode = [strippedCode stringByReplacingCharactersInRange:secondRange withString:@""];
    NSLog(@"%@", strippedCode);
    return strippedCode;
}

- (NSDictionary*) returnDataStores:(NSString*)goodString codeType:(NSString*)codeType {
    
    defaults = [NSUserDefaults standardUserDefaults];
    storeNumber = [defaults valueForKey:@"storeNumber"];

    NSLog(storeNumber);
    
    if (goodString != nil) {
        NSString *URLStringStores = @"http://api.remix.bestbuy.com/v1/stores(storeId=";
        URLStringStores = [URLStringStores stringByAppendingString:storeNumber];
        URLStringStores = [URLStringStores stringByAppendingString:@")+products("];
        URLStringStores = [URLStringStores stringByAppendingString:codeType];
        URLStringStores = [URLStringStores stringByAppendingString:@"="];
        URLStringStores = [URLStringStores stringByAppendingString:goodString];
        URLStringStores = [URLStringStores stringByAppendingString:@")?apiKey=9xr8yxxbq2wthscxsspcy24z&format=json&show=storeId,storeType,name,city,region,products.name,products.sku,products"];
        NSURL *storesURL = [NSURL URLWithString:URLStringStores];
        
        NSLog(@"%@", storesURL);
        
        if (storesURL == nil) {
            return nil;
        }
        
        NSData *jsonDataStores = [NSData dataWithContentsOfURL:storesURL];
        
        NSError *error = nil;
        
        NSDictionary *dataDictionaryStores = [NSJSONSerialization JSONObjectWithData:jsonDataStores options:0 error:&error];
        
        NSLog(@"%@", dataDictionaryStores[@"to"]);
        
        return dataDictionaryStores;
    }
    return nil;
}


- (NSDictionary*) returnDataProducts:(NSString*)goodString codeType:(NSString*)codeType {
    [self postToMysql:goodString];
    if (goodString != nil) {
        NSString *URLStringProducts =  @"http://api.remix.bestbuy.com/v1/products(";
        URLStringProducts = [URLStringProducts stringByAppendingString:codeType];
        URLStringProducts = [URLStringProducts stringByAppendingString:@"="];
        URLStringProducts = [URLStringProducts stringByAppendingString:goodString];
        URLStringProducts = [URLStringProducts stringByAppendingString:@")?format=json&show=all&apiKey=9xr8yxxbq2wthscxsspcy24z"];
        
        NSURL *productURL = [NSURL URLWithString:URLStringProducts];
        
        if (productURL == nil) {
            return nil;
        }
        
        NSData *jsonDataProduct = [NSData dataWithContentsOfURL:productURL];
        
        NSError *error = nil;
        
        NSDictionary *dataDictionaryProducts = [NSJSONSerialization JSONObjectWithData:jsonDataProduct options:0 error:&error];
        
        NSLog(@"%@", dataDictionaryProducts[@"to"]);
        
        return dataDictionaryProducts;
    }
    return nil;
}

- (NSString*) determineScanString:(NSString*)detectionString {
    if ([detectionString length] == 31) {
        return [[Functions alloc] QRPopFlip:detectionString];
    } else if ([detectionString length] == 16) {
        return [[Functions alloc] BBYCustomPopFlip:detectionString];
    } else if ([detectionString length] == 13) {
        if ([detectionString hasPrefix:@"0"] && [detectionString length] > 1) {
            detectionString = [detectionString substringFromIndex:1];
            return detectionString;
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
    return nil;
}

- (NSString*) determineScanType:(NSString*)detectionString {
    if ([detectionString length] == 31) {
        return @"sku";
    } else if ([detectionString length] == 16) {
        return @"sku";
    } else if ([detectionString length] == 13) {
        return @"upc";
        } else {
            return nil;
        }
}

- (int) determineStoreLegit:(NSString*)storeNumber {
    NSString *storeString = [NSString stringWithFormat:@"%@%@%@", @"http://api.remix.bestbuy.com/v1/stores(storeId=", storeNumber, @")?format=json&apiKey=9xr8yxxbq2wthscxsspcy24z"];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSData *dataAPIURL = [NSData dataWithContentsOfURL:storeURL];
    
    NSError *error = nil;
    
    NSDictionary *storeCheckDict = [NSJSONSerialization JSONObjectWithData:dataAPIURL options:0 error:&error];
    
    NSLog(@"%@", storeCheckDict[@"to"]);
    
    int storeCheck = [[storeCheckDict objectForKey:@"to"] intValue];
    
    NSLog(@"%i", storeCheck);
    
    if (storeCheck == 0) {
        NSLog(@"Return 0");
        return 0;
    }
    NSLog(@"Return 1");
    return 1;
}

@end
