//
//  SpecsViewController.m
//  Scanner2
//
//  Created by Frank Barrett on 7/1/15.
//  Copyright (c) 2015 Frank Barrett. All rights reserved.
//

#import "SpecsViewController.h"

@interface SpecsViewController () {
    UIButton *done;
}

@end

@implementation SpecsViewController

@synthesize productResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1];
    
    done = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 40, 40)];
    [done setBackgroundImage:[UIImage imageNamed:@"leftarrowwhite10pt"] forState:UIControlStateNormal];
    [done addTarget:self
             action:@selector(doneButton:)
   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:done];
    
    
    NSLog(@"%lu", (unsigned long)[productResult[@"products"][0][@"details"] count]);
    
    double height = 65;
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height-90)];
    
    for (int i = 0; i < [productResult[@"products"][0][@"details"] count]; i++) {
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+(height*i), self.view.bounds.size.width, 30)];
        NSLog(@"%@", productResult[@"products"][0][@"details"][i][@"name"]);
        name.text = productResult[@"products"][0][@"details"][i][@"name"];
        name.textColor = [UIColor whiteColor];
        [name setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(20, 30+(height*i), self.view.bounds.size.width, 20)];
        value.text = productResult[@"products"][0][@"details"][i][@"value"];
        value.textColor = [UIColor whiteColor];
        [value setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [scrollview addSubview:value];
        [scrollview addSubview:name];
    }
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, height *[productResult[@"products"][0][@"details"] count]);
    
    
    [self.view addSubview:scrollview];
    
    
}

- (IBAction) doneButton: (id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
