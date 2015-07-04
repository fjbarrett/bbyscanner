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
#import "SpecsViewController.h"

@interface PrimaryViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *view1;
    UIView *view2;
    UIView *previewView;
    UIView *_highlightView;
    UIView *topBack;
    UIView *bottomBack;
    UIView *cancelButtonView;
    UILabel *_label;
    UILabel *name;
    UILabel *salePriceLabel;
    UILabel *skuLabel;
    NSString *salePriceString;
    UIView *_line;
    UIButton *_button;
    UIButton *specsButton;
    UIButton *initScanButton;
    UIButton *cancelButton;
    UIButton *scanButton;
    UIButton *magButton;
    UIButton *moveButton;
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
    
    view1.backgroundColor = [UIColor blackColor];
    
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    
    NSLog(@"Height %f", height);
    NSLog(@"Width %f", width);
    scannerBottom = height-(height-((height/2)+100));
    scannerTop = height-(height-((height/2)-100));
    
    view1 = [[UIView alloc] init];
    view1.frame = CGRectMake(0, 0, width, height);
    [self.view addSubview:view1];
    [self.view bringSubviewToFront:view1];
    view1.userInteractionEnabled = YES;
    
    [self initSession];
    
    
    topBack = [[UIView alloc] init];
    topBack.frame = CGRectMake(0, 0, width, (height/2)-120);
    topBack.backgroundColor = [UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1];
    topBack.alpha = 0.90;
    [view1 addSubview:topBack];
    
    bottomBack = [[UIView alloc] init];
    bottomBack.frame = CGRectMake(0, (height/2)+120, width, (height/2));
    bottomBack.backgroundColor = [UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1];
    bottomBack.alpha = 0.90;
    [view1 addSubview:bottomBack];
    
    
    cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    [cancelButton addTarget:self
                     action:@selector(cancelButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchDown];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchUpOutside];
    [view1 addSubview:cancelButton];
    [view1 bringSubviewToFront:cancelButton];
    
//    moveButton = [[UIButton alloc] init];
//    moveButton.frame = CGRectMake(width-50, height-50, 50, 50);
//    [moveButton addTarget:self
//                     action:@selector(moveButton:)
//           forControlEvents:UIControlEventTouchUpInside];
//    moveButton.backgroundColor = [UIColor whiteColor];
//    [moveButton setTitle:@"Move" forState:UIControlStateNormal];
//    [view1 addSubview:moveButton];
//    [view1 bringSubviewToFront:moveButton];
    
    
    barcode = [[UIImageView alloc] init];
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (((height-scannerBottom)/2))-50, 80, 80);
    barcode.image = [UIImage imageNamed:@"whitebarcode"];
    [view1 addSubview:barcode];
    [view1 bringSubviewToFront:barcode];
    
   
    
//    magButton = [[UIButton alloc] init];
//    magButton.frame = CGRectMake(self.view.bounds.size.width-60, 30, 40, 40);
//    magButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [magButton addTarget:self
//                       action:@selector(initScanButton:)
//             forControlEvents:UIControlEventTouchUpInside];
//    [magButton setBackgroundImage:[UIImage imageNamed:@"mag"] forState:UIControlStateNormal];
//    [magButton setBackgroundImage:[UIImage imageNamed:@"mag"] forState:UIControlEventTouchDown];
//    [magButton setBackgroundImage:[UIImage imageNamed:@"mag"] forState:UIControlEventTouchUpInside];
//    [magButton setBackgroundImage:[UIImage imageNamed:@"mag"] forState:UIControlEventTouchUpOutside];
//    [self.view addSubview:magButton];
//    [self.view bringSubviewToFront:magButton];
    
    
//    _line = [[UIView alloc] init];
//    _line.frame = CGRectMake((self.view.bounds.size.width/2)-150, (self.view.bounds.size.height / 2)-50, 300, 100);
//    _line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _line.layer.borderColor = [UIColor whiteColor].CGColor;
//    _line.layer.borderWidth = 1;
//    [self.view addSubview:_line];
    
    
    name = [[UILabel alloc] init];
    name.frame = CGRectMake(width, (((height-scannerBottom)/2))-50, self.view.bounds.size.width-150, 40);
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    name.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.text = nil;
    [view1 addSubview:name];
    [name setAlpha:0];
    
    salePriceLabel = [[UILabel alloc] init];
    salePriceLabel.frame = CGRectMake(width, (((height-scannerBottom)/2)-16), self.view.bounds.size.width, 40);
    [salePriceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
    salePriceLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    salePriceLabel.textColor = [UIColor whiteColor];
    salePriceLabel.textAlignment = NSTextAlignmentLeft;
    salePriceLabel.text = nil;
    [view1 addSubview:salePriceLabel];
    [salePriceLabel setAlpha:0];
    
    skuLabel = [[UILabel alloc] init];
    skuLabel.frame = CGRectMake(30, (height/2)-168, 200, 40);
    [skuLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    skuLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    skuLabel.textColor = [UIColor whiteColor];
    skuLabel.textAlignment = NSTextAlignmentLeft;
    skuLabel.text = nil;
    [view1 addSubview:skuLabel];
    
    
    
    outStockImg = [[UIImageView alloc] init];
    outStockImg.frame = CGRectMake((width/2)-75, (height/2)-75, 150, 150);
    outStockImg.image = [UIImage imageNamed:@"scanned-x-bluered"];
    [outStockImg setAlpha:0];
    
    
    
    
    [view1 bringSubviewToFront:name];
    [view1 bringSubviewToFront:salePriceLabel];
    [view1 bringSubviewToFront:_label];
    
    [view1 addSubview:badUPCImg];
    
    
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
            NSLog(@"Product Class %@", [productResult class]);
            if ([productResult[@"products"] count] != NULL) {
                salePrice = productResult[@"products"][0][@"salePrice"];
                salePriceDouble = fabs(salePrice.doubleValue);
                skuLabel.text = [NSString stringWithFormat:@"SKU: %@",productResult[@"products"][0][@"sku"]];
            };
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
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (((height-scannerBottom)/2))-50, 80, 80);
    salePriceLabel.frame = CGRectMake(width, (((height-scannerBottom)/2)-16), self.view.bounds.size.width, 40);
    name.frame = CGRectMake(width, (((height-scannerBottom)/2))-50, self.view.bounds.size.width-150, 40);
    [UIView commitAnimations];
    previewView.frame = CGRectMake(0, 0, width, height);
    [_line setAlpha:1];
    [inStockImg setAlpha:0];
    [outStockImg setAlpha:0];
    [badUPCImg setAlpha:0];
    [_button removeFromSuperview];
    [specsButton removeFromSuperview];
    [_session performSelectorInBackground:@selector(startRunning) withObject:nil];
    skuLabel.text = nil;
}

- (IBAction) specsButton: (id) sender {
    [self performSegueWithIdentifier:@"toSpecs" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toSpecs"]){
        SpecsViewController *controller = (PrimaryViewController *)segue.destinationViewController;
        controller.productResult = productResult;
        controller.storeResult = storeResult;
    }
}

- (IBAction) moveButton: (id) sender {
    [self initView2];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    view1.frame = CGRectMake(-width, 0, width, height);
    view2.frame = CGRectMake(0, 0, width, height);
    [UIView commitAnimations];
    
}

- (IBAction) cancelButton: (id) sender {
    scanButton = [[UIButton alloc] init];
    scanButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    scanButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [scanButton addTarget:self
                       action:@selector(scanButton:)
             forControlEvents:UIControlEventTouchUpInside];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlStateNormal];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchDown];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchUpInside];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchUpOutside];
    [view1 addSubview:scanButton];
    [view1 bringSubviewToFront:scanButton];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.3];
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (height/2)-120, 80, 80);
    scanButton.frame =  scanButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height/2)+64, 240, 64);
    topBack.frame = CGRectMake(0, 0, width, height/2);
    topBack.alpha = 1;
    bottomBack.frame = CGRectMake(0, height/2, width, height/2);
    bottomBack.alpha = 1;
    [UIView commitAnimations];
    [cancelButton removeFromSuperview];
}

- (IBAction) scanButton: (id) sender {
    cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height/2)+64, 240, 64);
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [cancelButton addTarget:self
                     action:@selector(cancelButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchDown];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchUpOutside];
    [view1 addSubview:cancelButton];
    [view1 bringSubviewToFront:cancelButton];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:.4];
    topBack.frame = CGRectMake(0, 0, width, (height/2)-120);
    topBack.alpha = 0.90;
    bottomBack.frame = CGRectMake(0, (height/2)+120, width, (height/2));
    bottomBack.alpha = 0.90;
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (((height-scannerBottom)/2))-50, 80, 80);
    cancelButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    [UIView commitAnimations];
    [specsButton removeFromSuperview];
    [scanButton removeFromSuperview];
    scanButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    [_session performSelectorInBackground:@selector(startRunning) withObject:nil];
    skuLabel.text = nil;
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
    
    previewView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    previewView.backgroundColor = [UIColor blackColor];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [view1 addSubview:previewView];
    [previewView.layer addSublayer:_prevLayer];
    [view1 sendSubviewToBack:previewView];
    
    [_session startRunning];
}

- (void) addButton {
    _button = [[UIButton alloc] init];
    _button.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_button addTarget:self
                action:@selector(_button:)
      forControlEvents:UIControlEventTouchUpInside];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchDown];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchUpInside];
    [_button setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchUpOutside];
    [view1 addSubview:_button];
    [view1 bringSubviewToFront:_button];
}


- (void) goodScan:(NSString*)pullDetectionString typeofCode:(NSString *)typeofCode {
//    [self initProductImage:pullDetectionString typeofCode:typeofCode];
    [self addSpecsButton];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    barcode.frame = CGRectMake(40, (((height-scannerBottom)/2))-50, 80, 80);
//    productImage.frame = CGRectMake((width/2)-(newWidth/2), (height/2)-(newHeight/2), newWidth, newHeight);
    previewView.frame = CGRectMake(0, 0, width, height);
    [name setAlpha:1];
    [salePriceLabel setAlpha:1];
    highlightViewRect = CGRectZero;
    specsButton.frame = CGRectMake(width-150, (height/2)-168, 120, 30);
    name.frame = CGRectMake(140, (((height-scannerBottom)/2))-50, self.view.bounds.size.width-150, 40);
    salePriceLabel.frame = CGRectMake(140, (((height-scannerBottom)/2)-16), self.view.bounds.size.width, 40);
    [UIView commitAnimations];
    
    inStockImg = [[UIImageView alloc] init];
    inStockImg.layer.frame = CGRectMake((width/2)-75, (height/2)-75, 150, 150);
    inStockImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    inStockImg.image = [UIImage imageNamed:@"roundcheckmark-green"];
    [view1 addSubview:inStockImg];
    [inStockImg setAlpha:1];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    inStockImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    inStockImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.2];
    inStockImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    inStockImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView commitAnimations];
    
    [self addButton];
}

- (void) goodScanOut:(NSString*)pullDetectionString typeofCode:(NSString *)typeofCode {
    [view1 addSubview:outStockImg];
    [self addSpecsButton];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    barcode.frame = CGRectMake(40, (((height-scannerBottom)/2))-50, 80, 80);
//    CGRect rect = [outStockImg frame];
    [outStockImg setAlpha:1];
    [name setAlpha:1];
    [salePriceLabel setAlpha:1];
    highlightViewRect = CGRectZero;
    name.frame = CGRectMake(140, (((height-scannerBottom)/2))-50, self.view.bounds.size.width-150, 40);
    salePriceLabel.frame = CGRectMake(140, (((height-scannerBottom)/2)-16), self.view.bounds.size.width, 40);
    specsButton.frame = CGRectMake(width-150, (height/2)-168, 120, 30);
    [UIView commitAnimations];
    [self addButton];
}

- (void) badUPC {
    badUPCImg = [[UIImageView alloc] init];
    badUPCImg.layer.frame = CGRectMake((self.view.bounds.size.width/2)-75, (self.view.bounds.size.height/2)-75, 150, 150);
    badUPCImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    badUPCImg.image = [UIImage imageNamed:@"scanned-x-red"];
    [view1 addSubview:badUPCImg];
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

-(void) addSpecsButton {
    specsButton = [[UIButton alloc] init];
    specsButton.frame = CGRectMake(width, (height/2)-168, 120, 30);
    [specsButton addTarget:self
                    action:@selector(specsButton:)
      forControlEvents:UIControlEventTouchUpInside];
    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlStateNormal];
    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlEventTouchDown];
    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlEventTouchUpInside];
    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlEventTouchUpOutside];
    [view1 addSubview:specsButton];
    [view1 bringSubviewToFront:specsButton];
}

-(void) initView2 {
    view2 = [[UIView alloc] init];
    view2.frame = CGRectMake(width, 0, width, height);
    [self.view addSubview:view2];
    [self.view bringSubviewToFront:view2];
    view2.backgroundColor = [UIColor blackColor];
}



- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        NSLog(@"%@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}


@end