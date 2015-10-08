//
//  SetStoreViewController.m
//  BBYScanner
//
//  Created by Frank Barrett on 7/19/15.
//  Copyright (c) 2015 Frank Barrett. All rights reserved.
//

#import "SetStoreViewController.h"
#import "Functions.h"

@interface SetStoreViewController () {
    UIButton *done;
    UIButton *saveButton;
    UILabel *viewTitle;
    UITextField *tf;
    CGFloat height;
    CGFloat width;
    NSString *storeNumber;
    Functions *functions;
}

@end

@implementation SetStoreViewController

- (void)viewDidLoad {
    
    height = self.view.bounds.size.height;
    width = self.view.bounds.size.width;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    storeNumber = [defaults valueForKey:@"storeNumber"];
    
    self.view.backgroundColor = [UIColor colorWithRed:2/255.0 green:45/255.0 blue:82/255.0 alpha:1];
    
    done = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 40, 40)];
    [done setBackgroundImage:[UIImage imageNamed:@"leftarrowwhite"] forState:UIControlStateNormal];
    [done addTarget:self
             action:@selector(doneButton:)
   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:done];
    
    viewTitle = [[UILabel alloc] initWithFrame:CGRectMake(((width)/2)-150, ((height)/2)-180, 300, 40)];
    viewTitle.text = @"Set Store Number";
    viewTitle.textColor = [UIColor whiteColor];
    viewTitle.textAlignment = UITextAlignmentCenter;
    viewTitle.font = [UIFont fontWithName:@"SFUIText-Regular" size:25];
    [self.view addSubview:viewTitle];

    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(((width)/2)-100, ((height)/2)-120, 200, 40)];
    tf.textColor = [UIColor whiteColor];
    tf.font = [UIFont fontWithName:@"SFUIText-Regular" size:25];
//    tf.backgroundColor=[UIColor whiteColor];
    tf.text= storeNumber;
    tf.textAlignment = UITextAlignmentCenter;
    tf.layer.borderWidth = 1.0;
    tf.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    [self.view addSubview:tf];
    
    saveButton = [[UIButton alloc] initWithFrame:CGRectMake(((width)/2)-100, ((height)/2)-50, 200, 40)];
    saveButton.backgroundColor = [UIColor whiteColor];
    saveButton.titleLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:20];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self
             action:@selector(saveButtonAction:)
   forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:saveButton];
    
    [super viewDidLoad];
    
}


- (IBAction) saveButtonAction: (id) sender {
    functions = [[Functions alloc] init];
    if ([functions determineStoreLegit:[tf text]] == 1) {
        NSLog(@"Testing %i", [functions determineStoreLegit:[tf text]]);
        NSString *storeNumber = [tf text];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:storeNumber forKey:@"storeNumber"];
        [defaults synchronize];
        NSLog(@"Data saved");
        [functions postToMysql:tf.text];
        [tf resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        viewTitle.text = @"Store does not exist";
        viewTitle.textColor = [UIColor redColor];
    }
    
}

- (IBAction) doneButton: (id) sender {
    functions = [[Functions alloc] init];
    if ([functions determineStoreLegit:[tf text]] == 1) {
        NSLog(@"Testing %i", [functions determineStoreLegit:[tf text]]);
        NSString *storeNumber = [tf text];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:storeNumber forKey:@"storeNumber"];
        [defaults synchronize];
        NSLog(@"Data saved");
        [functions postToMysql:tf.text];
        [tf resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        viewTitle.text = @"Store does not exist";
        viewTitle.textColor = [UIColor redColor];
    }
}


@end
