//
//  ViewController.m
//  TodayExtentsionDemo
//
//  Created by Sylar on 2019/4/9.
//  Copyright © 2019年 Sylar. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "TodayExtentsionDemoTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSArray *sourcesArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _sourcesArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"3", nil];
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [_mainTableView registerClass:[TodayExtentsionDemoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TodayExtentsionDemoTableViewCell class])];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    imageView.frame = CGRectMake( 0, 0, imageView.frame.size.width, imageView.frame.size.height);
    [self.view addSubview:imageView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourcesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodayExtentsionDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TodayExtentsionDemoTableViewCell class])];
    cell.textLabel.text = _sourcesArray[indexPath.row];
    return cell;
}
@end
