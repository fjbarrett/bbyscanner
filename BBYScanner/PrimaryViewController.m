//
//  PrimaryViewController.h
//  BBYScanner
//
//  Created by Frank Barrett on 6/25/15.
//  Copyright (c) 2015 Frank Barrett. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "PrimaryViewController.h"
#import <Foundation/Foundation.h>
#import "Functions.h"
#import <QuartzCore/QuartzCore.h>

@interface PrimaryViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *previewView;
    UIView *_highlightView;
    UILabel *_label;
    UILabel *name;
    UILabel *salePriceLabel;
    NSString *salePriceString;
    UIView *_line;
    UIButton *_button;
    UIButton *initScanButton;
    UIButton *cancelButton;
    NSString *detectionString;
    UIImageView *barcode;
    UIImageView *inStockImg;
    UIImageView *outStockImg;
    UIImageView *badUPCImg;
    UIImageView *productImage;
    CGRect highlightViewRect;
    UIActivityIndicatorView *spinner;
    Functions *functions;
    CGFloat height;
    CGFloat width;
    CGFloat scannerBottom;
    CGFloat scannerTop;
    NSString *newDetectionString;
    NSString *newDetectionType;
    NSDictionary *productResult;
    NSDictionary *storeResult;
    NSDictionary *productDict;
    NSNumber *salePrice;
    double salePriceDouble;
    double newWidth;
    double newHeight;
    double ratio;
    
}
@end

@implementation PrimaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    scannerBottom = height-(height-((height/2)+100));
    scannerTop = height-(height-((height/2)-100));
    
    self.view.backgroundColor = [UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
    barcode = [[UIImageView alloc] init];
    barcode.frame = CGRectMake(self.view.bounds.size.width, (height/2)-120, 80, 80);
    barcode.image = [UIImage imageNamed:@"whitebarcode"];
    [self.view addSubview:barcode];
    [self.view bringSubviewToFront:barcode];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (height/2)-120, 80, 80);
    
    [UIView commitAnimations];
    
    initScanButton = [[UIButton alloc] init];
    initScanButton.frame = CGRectMake(-240, (height/2)+64, 240, 64);
    initScanButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [initScanButton addTarget:self
                action:@selector(initScanButton:)
      forControlEvents:UIControlEventTouchUpInside];
    [initScanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-init"] forState:UIControlStateNormal];
    [initScanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-pressed"] forState:UIControlEventTouchDown];
    [initScanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-init"] forState:UIControlEventTouchUpInside];
    [initScanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-init"] forState:UIControlEventTouchUpOutside];
    [self.view addSubview:initScanButton];
    [self.view bringSubviewToFront:initScanButton];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    initScanButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height/2)+64, 240, 64);
    
    [UIView commitAnimations];
    
//    _line = [[UIView alloc] init];
//    _line.frame = CGRectMake((self.view.bounds.size.width/2)-150, (self.view.bounds.size.height / 2)-50, 300, 100);
//    _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _line.layer.borderColor = [UIColor whiteColor].CGColor;
//    _line.layer.borderWidth = 1;
//    [self.view addSubview:_line];
    
    name = [[UILabel alloc] init];
    name.frame = CGRectMake(width, (((height-scannerBottom)/2))-40, self.view.bounds.size.width-150, 40);
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    name.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.text = nil;
    [self.view addSubview:name];
    [name setAlpha:0];
    
    salePriceLabel = [[UILabel alloc] init];
    salePriceLabel.frame = CGRectMake(width, (((height-scannerBottom)/2)), self.view.bounds.size.width, 40);
    [salePriceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
    salePriceLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    salePriceLabel.textColor = [UIColor whiteColor];
    salePriceLabel.textAlignment = NSTextAlignmentLeft;
    salePriceLabel.text = nil;
    [self.view addSubview:salePriceLabel];
    [salePriceLabel setAlpha:0];
    
    inStockImg = [[UIImageView alloc] init];
    inStockImg.frame = CGRectMake(0, 0, 50, 50);
    inStockImg.image = [UIImage imageNamed:@"scanned-checkmark-bluegreen"];
    [inStockImg setAlpha:0];
    
    outStockImg = [[UIImageView alloc] init];
    outStockImg.frame = CGRectMake(0, 0, 50, 50);
    outStockImg.image = [UIImage imageNamed:@"scanned-x-bluered"];
    [outStockImg setAlpha:0];
    
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:name];
    [self.view bringSubviewToFront:salePriceLabel];
    [self.view bringSubviewToFront:_label];
    [self.view bringSubviewToFront:_line];
    
    [self.view addSubview:badUPCImg];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypeInterleaved2of5Code,
                              AVMetadataObjectTypeITF14Code,
                              AVMetadataObjectTypeDataMatrixCode
                              ];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            [_session stopRunning];
            [_line setAlpha:0];
            NSLog(@"%i",[detectionString length]);
            NSLog(@"%@",detectionString);
            functions = [[Functions alloc] init];
            newDetectionString = [functions determineScanString:detectionString];
            newDetectionType = [functions determineScanType:detectionString];
            productResult = [functions returnDataProducts:newDetectionString codeType:newDetectionType];
            storeResult = [functions returnDataStores:newDetectionString codeType:newDetectionType];
            salePrice = productResult[@"products"][0][@"salePrice"];
            salePriceDouble = fabs(salePrice.doubleValue);
            if (storeResult != nil && productResult != nil) {
                NSLog(@"%@", productResult);
                NSLog(@"%@", storeResult);
                if ([productResult[@"to"] intValue] == 1 && [storeResult[@"to"] intValue] == 1) {
                    [self goodScan:newDetectionString typeofCode:newDetectionType];
                    name.text = productResult[@"products"][0][@"name"];
                    salePriceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", salePriceDouble];
                } else if ([productResult[@"to"] intValue] == 1 && [storeResult[@"to"] intValue] == 0) {
                    name.text = productResult[@"products"][0][@"name"];
                    salePriceLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", salePriceDouble];
                    [self goodScanOut:newDetectionString typeofCode:newDetectionType];
                } else if ([productResult[@"to"] intValue] == 0 && [storeResult[@"to"] intValue] == 0) {
                    [self badUPC];
                }
                highlightViewRect = CGRectZero;
            } else {
                [self badUPC];
            }
        }
            }
            _highlightView.frame = highlightViewRect;
}

- (IBAction) _button: (id) sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (((height-scannerBottom)/2))-40, 80, 80);
    salePriceLabel.frame = CGRectMake(width, (((height-scannerBottom)/2)), self.view.bounds.size.width, 40);
    name.frame = CGRectMake(width, (((height-scannerBottom)/2))-40, self.view.bounds.size.width-150, 40);
    previewView.frame = CGRectMake(20, ((self.view.bounds.size.height/2)-100), self.view.bounds.size.width-40, 200);
    productImage.frame = CGRectMake(-newWidth, (height/2)-(newHeight/2), newWidth, newHeight);
    [UIView commitAnimations];
    [_line setAlpha:1];
    [inStockImg setAlpha:0];
    [outStockImg setAlpha:0];
    [badUPCImg setAlpha:0];
    [_button removeFromSuperview];
    [_session performSelectorInBackground:@selector(startRunning) withObject:nil];
}

- (IBAction) cancelButton: (id) sender {
    [self.view addSubview:initScanButton];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.3];
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (height/2)-120, 80, 80);
    initScanButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height/2)+64, 240, 64);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    previewView.frame = CGRectMake(width, ((self.view.bounds.size.height/2)-100), self.view.bounds.size.width-40, 200);
    [UIView commitAnimations];
    [cancelButton removeFromSuperview];
}

- (IBAction) initScanButton: (id) sender {
    cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height/2)+64, 240, 64);
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [cancelButton addTarget:self
                action:@selector(cancelButton:)
      forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"scan-button-cancel"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"scan-button-pressed"] forState:UIControlEventTouchDown];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"scan-button-cancel"] forState:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"scan-button-cancel"] forState:UIControlEventTouchUpOutside];
    [self.view addSubview:cancelButton];
    [self.view bringSubviewToFront:cancelButton];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:.4];
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (((height-scannerBottom)/2))-40, 80, 80);
    cancelButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    [UIView commitAnimations];
    [self performSelectorInBackground:@selector(initSession) withObject:nil];
    [initScanButton removeFromSuperview];
    initScanButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    [_session startRunning];
}

- (void) flyVideoIn {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    previewView.frame = CGRectMake(20, ((self.view.bounds.size.height/2)-100), self.view.bounds.size.width-40, 200);
    [UIView commitAnimations];
}

- (void)initSession
{
    previewView = [[UIView alloc] init];
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    previewView.frame = CGRectMake(-(self.view.bounds.size.width-40), ((self.view.bounds.size.height/2)-100), self.view.bounds.size.width-40, 200);
    previewView.backgroundColor = [UIColor blackColor];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width-40, 200);
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view addSubview:previewView];
    [self.view bringSubviewToFront:previewView];
    [previewView.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    [self flyVideoIn];
}

- (void) addButton {
    _button = [[UIButton alloc] init];
    _button.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_button addTarget:self
                action:@selector(_button:)
      forControlEvents:UIControlEventTouchUpInside];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-invert"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-pressed"] forState:UIControlEventTouchDown];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-invert"] forState:UIControlEventTouchUpInside];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-invert"] forState:UIControlEventTouchUpOutside];
    [self.view addSubview:_button];
    [self.view bringSubviewToFront:_button];
}

- (void) initProductImage:(NSString*)pullDetectionString typeofCode:(NSString *)typeofCode {
    productDict = [functions returnDataProducts:pullDetectionString codeType:typeofCode];
    NSLog(@"%@", productDict[@"products"][0][@"largeImage"]);
    productImage = [[UIImageView alloc] init];
    productImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:productDict[@"products"][0][@"largeImage"]]]];

    NSLog(@"%f", productImage.image.size.height);
    NSLog(@"%f", productImage.image.size.width);
    ratio = productImage.image.size.height/productImage.image.size.width;
    NSLog(@"%f", ratio);
    if (ratio > 1) {
        if (productImage.image.size.height < 200) {
            newHeight = productImage.image.size.height + (200 - productImage.image.size.height);
        } else {
            newHeight = productImage.image.size.height - (productImage.image.size.height - 200);
        }
        newWidth = newHeight/ratio;
        NSLog(@"%f", newHeight);
        NSLog(@"%f", newWidth);
        NSLog(@"Go");
    } else {
        if (productImage.image.size.width < 200) {
            newWidth = productImage.image.size.width + (200 - productImage.image.size.width);
        } else {
            newWidth = productImage.image.size.width - (productImage.image.size.width - 200);
        }
        newHeight = newWidth*ratio;
        NSLog(@"Go Else");
    }
    NSLog(@"%f", newHeight);
    NSLog(@"%f", newWidth);

    productImage.frame = CGRectMake(-newWidth, (height/2)-(newHeight/2), newWidth, newHeight);
    [self.view addSubview:productImage];
    [self.view bringSubviewToFront:productImage];
}

- (void) goodScan:(NSString*)pullDetectionString typeofCode:(NSString *)typeofCode {
    [self initProductImage:pullDetectionString typeofCode:typeofCode];
    [productImage addSubview:inStockImg];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    barcode.frame = CGRectMake(40, (((height-scannerBottom)/2))-40, 80, 80);
    productImage.frame = CGRectMake((width/2)-(newWidth/2), (height/2)-(newHeight/2), newWidth, newHeight);
    previewView.frame = CGRectMake(self.view.bounds.size.width, ((self.view.bounds.size.height/2)-100), self.view.bounds.size.width-40, 200);
    [inStockImg setAlpha:1];
    [name setAlpha:1];
    [salePriceLabel setAlpha:1];
    highlightViewRect = CGRectZero;
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.30];
    name.frame = CGRectMake(140, (((height-scannerBottom)/2))-40, self.view.bounds.size.width-150, 40);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.55];
    salePriceLabel.frame = CGRectMake(140, (((height-scannerBottom)/2)), self.view.bounds.size.width, 40);
    [UIView commitAnimations];
    
    [self addButton];
}

- (void) goodScanOut:(NSString*)pullDetectionString typeofCode:(NSString *)typeofCode {
    [self initProductImage:pullDetectionString typeofCode:typeofCode];
    [productImage addSubview:outStockImg];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    barcode.frame = CGRectMake(40, (((height-scannerBottom)/2))-40, 80, 80);
    productImage.frame = CGRectMake((width/2)-(newWidth/2), (height/2)-(newHeight/2), newWidth, newHeight);
    previewView.frame = CGRectMake(self.view.bounds.size.width, ((self.view.bounds.size.height/2)-100), self.view.bounds.size.width-40, 200);
//    CGRect rect = [outStockImg frame];
    [outStockImg setAlpha:1];
    [name setAlpha:1];
    [salePriceLabel setAlpha:1];
    highlightViewRect = CGRectZero;
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.30];
    name.frame = CGRectMake(140, (((height-scannerBottom)/2))-40, self.view.bounds.size.width-150, 40);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.55];
    salePriceLabel.frame = CGRectMake(140, (((height-scannerBottom)/2)), self.view.bounds.size.width, 40);
    [UIView commitAnimations];
    [self addButton];
}

- (void) badUPC {
    badUPCImg = [[UIImageView alloc] init];
    badUPCImg.layer.frame = CGRectMake((self.view.bounds.size.width/2)-75, (self.view.bounds.size.height/2)-75, 150, 150);
    badUPCImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    badUPCImg.image = [UIImage imageNamed:@"scanned-x-red"];
    [self.view addSubview:badUPCImg];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    badUPCImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    badUPCImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    highlightViewRect = CGRectZero;
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.2];
    badUPCImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    badUPCImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    highlightViewRect = CGRectZero;
    [UIView commitAnimations];
    [self addButton];
}


@end