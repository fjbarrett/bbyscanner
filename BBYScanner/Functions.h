//
//  Functions.h
//  BBYScanner
//
//  Created by Frank Barrett on 6/25/15.
//  Copyright (c) 2015 Frank Barrett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Functions : NSObject

- (NSString*) BBYCustomPopFlip:(NSString*)string;
- (NSString*) QRPopFlip:(NSString*)string;
- (void) postToMysql:(NSString*)string;
- (NSString*) determineScanString:(NSString*)detectionString;
- (NSString*) determineScanType:(NSString*)detectionString;
- (int) determineStoreLegit:(NSString*)storeNumber;
- (NSDictionary*) returnDataProducts:(NSString*)goodString codeType:(NSString*)codeType;
- (NSDictionary*) returnDataStores:(NSString*)goodString codeType:(NSString*)codeType;

@end
