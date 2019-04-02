//
//  PodResourceViewController.m
//  PodUseResource
//
//  Created by swlfigo on 04/02/2019.
//  Copyright (c) 2019 swlfigo. All rights reserved.
//

#import "PodResourceViewController.h"
#import <PodUseResource/PodSubViewController.h>

@interface PodResourceViewController ()

@end

@implementation PodResourceViewController

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
    [self presentViewController:[PodSubViewController new] animated:YES completion:nil];
}

@end
