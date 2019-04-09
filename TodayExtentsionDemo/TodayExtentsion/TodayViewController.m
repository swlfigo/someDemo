//
//  TodayViewController.m
//  TodayExtentsion
//
//  Created by Sylar on 2019/4/9.
//  Copyright © 2019年 Sylar. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <AFNetworking/AFNetworking.h>

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSArray *sourcesArray;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _sourcesArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"3", nil];
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [_mainTableView registerClass:[TodayExtentsionDemoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TodayExtentsionDemoTableViewCell class])];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    imageView.frame = CGRectMake( 0, 0, imageView.frame.size.width, imageView.frame.size.height);
    [self.view addSubview:imageView];
    
    if (@available(iOS 10.0, *)) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }else{

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourcesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodayExtentsionDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TodayExtentsionDemoTableViewCell class])];
    cell.textLabel.text = _sourcesArray[indexPath.row];
    return cell;
}


//最大只能527? screen - 140
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        // 设置展开的新高度
//        self.preferredContentSize = CGSizeMake(0, 10000);
        CGFloat maxHeight = [[ UIScreen mainScreen ] bounds ].size.height - 139;
        self.preferredContentSize = CGSizeMake(0, maxHeight);
    }else{
        self.preferredContentSize = maxSize;
    }
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
