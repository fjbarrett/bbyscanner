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
    
    BOOL firstScan;
    
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
    UILabel *reportLabel;
    NSString *salePriceString;
    UIView *_line;
    UIButton *_button;
    UIButton *specsButton;
    UIButton *initScanButton;
    UIButton *cancelButton;
    UIButton *scanButton;
    UIButton *magButton;
    UIButton *moveButton;
    UIButton *compareButton;
    UIButton *setStoreButton;
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
    NSString *storeNumber;
    NSDictionary *productResult;
    NSDictionary *storeResult;
    NSDictionary *productResult2;
    NSDictionary *storeResult2;
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    storeNumber = [defaults objectForKey:@"storeNumber"];
    
    [super viewDidLoad];
    
    view1.backgroundColor = [UIColor blackColor];
    
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    
    NSLog(@"Height %f", height);
    NSLog(@"Width %f", width);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog(@"ScreenWidth %f", screenWidth);
    NSLog(@"ScreenHeight %f", screenHeight);
    NSLog(@"Scale %f", [UIScreen mainScreen].scale);
    
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
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitleColor:[UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:20];
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlStateNormal];
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchDown];
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchUpInside];
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelbutton"] forState:UIControlEventTouchUpOutside];
    [view1 addSubview:cancelButton];
    [view1 bringSubviewToFront:cancelButton];
    
    setStoreButton = [[UIButton alloc] init];
    setStoreButton.frame = CGRectMake((width/2)-60, height-40, 120, 30);
    [setStoreButton addTarget:self
                     action:@selector(setStoreButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [setStoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setStoreButton setTitle:storeNumber forState:UIControlStateNormal];
    setStoreButton.layer.cornerRadius = 1.0;
    setStoreButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:18];
    [view1 addSubview:setStoreButton];
    [view1 bringSubviewToFront:setStoreButton];

    
    
    barcode = [[UIImageView alloc] init];
    barcode.frame = CGRectMake((self.view.bounds.size.width/2)-40, (((height-scannerBottom)/2))-50, 80, 80);
    barcode.image = [UIImage imageNamed:@"barcode"];
    [view1 addSubview:barcode];
    [view1 bringSubviewToFront:barcode];
    
    name = [[UILabel alloc] init];
    name.frame = CGRectMake(width, (((height-scannerBottom)/2))-50, self.view.bounds.size.width-150, 40);
    [name setFont:[UIFont fontWithName:@"SFUIText-Light" size:20]];
    name.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.text = nil;
    [view1 addSubview:name];
    [name setAlpha:0];
    
    salePriceLabel = [[UILabel alloc] init];
    salePriceLabel.frame = CGRectMake(width, (((height-scannerBottom)/2)-16), self.view.bounds.size.width, 40);
    [salePriceLabel setFont:[UIFont fontWithName:@"SFUIText-Light" size:30]];
    salePriceLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    salePriceLabel.textColor = [UIColor whiteColor];
    salePriceLabel.textAlignment = NSTextAlignmentLeft;
    salePriceLabel.text = nil;
    [view1 addSubview:salePriceLabel];
    [salePriceLabel setAlpha:0];
    
    reportLabel = [[UILabel alloc] init];
    reportLabel.frame = CGRectMake((width/2)-75, scannerBottom+30, 150, 40);
    [reportLabel setFont:[UIFont fontWithName:@"SFUIText-Light" size:20]];
    reportLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    reportLabel.textColor = [UIColor whiteColor];
    reportLabel.textAlignment = NSTextAlignmentCenter;
    reportLabel.text = nil;
    [view1 addSubview:reportLabel];
    [reportLabel setAlpha:0];
    
    skuLabel = [[UILabel alloc] init];
    skuLabel.frame = CGRectMake(30, (height/2)-168, 200, 40);
    [skuLabel setFont:[UIFont fontWithName:@"SFUIText-Light" size:14]];
    skuLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    skuLabel.textColor = [UIColor whiteColor];
    skuLabel.textAlignment = NSTextAlignmentLeft;
    skuLabel.text = nil;
    [view1 addSubview:skuLabel];
    
    
    
    [view1 bringSubviewToFront:name];
    [view1 bringSubviewToFront:salePriceLabel];
    [view1 bringSubviewToFront:_label];

    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    storeNumber = [defaults valueForKey:@"storeNumber"];
    NSString *storeNumberDisplay = [NSString stringWithFormat:@"%@%@", @"Store #", storeNumber];
    
    if (storeNumber == NULL) {
        NSLog(@"yes");
        
        [self performSelector:@selector(setStoreButtonAction:) withObject:nil afterDelay:0.0];
    }
    
    [setStoreButton setTitle:storeNumberDisplay forState:UIControlStateNormal];
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
            [self runOneScan];
        }
    }
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
    reportLabel.text = nil;
}

- (IBAction) specsButton: (id) sender {
    [self performSegueWithIdentifier:@"toSpecs" sender:sender];
}

- (IBAction) setStoreButtonAction: (id) sender {
    [self performSegueWithIdentifier:@"toSetStore" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toSpecs"]){
        SpecsViewController *controller = (PrimaryViewController *)segue.destinationViewController;
        controller.productResult = productResult;
        controller.storeResult = storeResult;
    }
}

- (IBAction) cancelButton: (id) sender {
    scanButton = [[UIButton alloc] init];
    scanButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height-((height-scannerBottom)/2))-32, 240, 64);
    scanButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [scanButton addTarget:self
                       action:@selector(scanButton:)
             forControlEvents:UIControlEventTouchUpInside];
    [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    scanButton.backgroundColor = [UIColor whiteColor];
    [scanButton setTitleColor:[UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:20];
//    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlStateNormal];
//    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchDown];
//    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchUpInside];
//    [scanButton setBackgroundImage:[UIImage imageNamed:@"scan-button-2"] forState:UIControlEventTouchUpOutside];
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
    reportLabel.text = nil;
}

- (IBAction) scanButton: (id) sender {
    cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake((self.view.bounds.size.width/2)-120, (height/2)+64, 240, 64);
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [cancelButton addTarget:self
                     action:@selector(cancelButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitleColor:[UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:20];
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
    reportLabel.text = nil;
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
    [_button setTitle:@"Scan" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor whiteColor];
    [_button setTitleColor:[UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:20];
    [view1 addSubview:_button];
    [view1 bringSubviewToFront:_button];
}


- (void) goodScan:(NSString*)pullDetectionString typeofCode:(NSString *)typeofCode {
    [self addSpecsButton];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    barcode.frame = CGRectMake(40, (((height-scannerBottom)/2))-50, 80, 80);
    previewView.frame = CGRectMake(0, 0, width, height);
    [name setAlpha:1];
    [salePriceLabel setAlpha:1];
    highlightViewRect = CGRectZero;
    specsButton.frame = CGRectMake(width-150, (height/2)-168, 120, 30);
    name.frame = CGRectMake(140, (((height-scannerBottom)/2))-50, self.view.bounds.size.width-150, 40);
    salePriceLabel.frame = CGRectMake(140, (((height-scannerBottom)/2)-16), self.view.bounds.size.width, 40);
    reportLabel.text = @"In stock";
    reportLabel.alpha = 1.0;
    [UIView commitAnimations];
    
    inStockImg = [[UIImageView alloc] init];
    inStockImg.layer.frame = CGRectMake((width/2)-75, (height/2)-75, 150, 150);
    inStockImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    inStockImg.image = [UIImage imageNamed:@"greencheck-2"];
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
    [view1 addSubview:compareButton];
    [view1 bringSubviewToFront:compareButton];
    [self addButton];
    
}

- (void) goodScanOut:(NSString*)pullDetectionString typeofCode:(NSString *)typeofCode {
    [view1 addSubview:outStockImg];
    [self addSpecsButton];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    barcode.frame = CGRectMake(40, (((height-scannerBottom)/2))-50, 80, 80);
    [name setAlpha:1];
    [salePriceLabel setAlpha:1];
    name.frame = CGRectMake(140, (((height-scannerBottom)/2))-50, self.view.bounds.size.width-150, 40);
    salePriceLabel.frame = CGRectMake(140, (((height-scannerBottom)/2)-16), self.view.bounds.size.width, 40);
    specsButton.frame = CGRectMake(width-150, (height/2)-168, 120, 30);
    reportLabel.text = @"Out of stock";
    reportLabel.alpha = 1.0;
    [UIView commitAnimations];
    
    outStockImg = [[UIImageView alloc] init];
    outStockImg.frame = CGRectMake((width/2)-75, (height/2)-75, 150, 150);
    outStockImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    outStockImg.image = [UIImage imageNamed:@"redx"];
    [view1 addSubview:outStockImg];
    outStockImg.alpha = 1.0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    outStockImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    outStockImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.2];
    outStockImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    outStockImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView commitAnimations];
    [self addButton];
}

- (void) badUPC {
    badUPCImg = [[UIImageView alloc] init];
    badUPCImg.layer.frame = CGRectMake((self.view.bounds.size.width/2)-75, (self.view.bounds.size.height/2)-75, 150, 150);
    badUPCImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    badUPCImg.image = [UIImage imageNamed:@"x-badscan"];
    [view1 addSubview:badUPCImg];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    badUPCImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    badUPCImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    reportLabel.text = @"Bad barcode";
    reportLabel.alpha = 1.0;
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.2];
    badUPCImg.layer.anchorPoint = CGPointMake(0.5, 0.5);
    badUPCImg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    highlightViewRect = CGRectZero;
    [UIView commitAnimations];
    [self addButton];
    reportLabel.text = @"Bad barcode";
}

-(void) addSpecsButton {
    specsButton = [[UIButton alloc] init];
    specsButton.frame = CGRectMake(width, (height/2)-168, 120, 30);
    [specsButton addTarget:self
                    action:@selector(specsButton:)
      forControlEvents:UIControlEventTouchUpInside];
    [specsButton setTitle:@"Specs" forState:UIControlStateNormal];
    specsButton.backgroundColor = [UIColor whiteColor];
    [specsButton setTitleColor:[UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1] forState:UIControlStateNormal];
    specsButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:14];
//    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlStateNormal];
//    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlEventTouchDown];
//    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlEventTouchUpInside];
//    [specsButton setBackgroundImage:[UIImage imageNamed:@"specs"] forState:UIControlEventTouchUpOutside];
    [view1 addSubview:specsButton];
    [view1 bringSubviewToFront:specsButton];
}

-(void) runOneScan {
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
    } else {
        [self badUPC];
    }
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

-(void) initView2 {
    view2 = [[UIView alloc] init];
    view2.frame = CGRectMake(width, 0, width, height);
    [self.view addSubview:view2];
    [self.view bringSubviewToFront:view2];
    view2.backgroundColor = [UIColor blackColor];
}




@end