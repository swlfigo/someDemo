//
//  subModuleViewController.m
//  Pod-Resource
//
//  Created by swlfigo on 04/01/2019.
//  Copyright (c) 2019 swlfigo. All rights reserved.
//

#import "subModuleViewController.h"
#import <Pod_Resource/SubModuleViewController.h>

@interface subModuleViewController ()

@end

@implementation subModuleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickMethod:(UIButton *)sender {
    [self presentViewController:[SubModuleViewController new] animated:YES completion:nil];
}

@end
