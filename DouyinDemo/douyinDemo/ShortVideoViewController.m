//
//  ShortVideoViewController.m
//  douyinDemo
//
//  Created by Sylar on 2019/7/21.
//  Copyright © 2019 Sylar. All rights reserved.
//

#import "ShortVideoViewController.h"
#import "ShortVideoTableViewCell.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
@interface ShortVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property (nonatomic, strong) NSArray *videoUrls;
@end

@implementation ShortVideoViewController

- (void)dealloc
{
    if ([KTVHTTPCache proxyIsRunning]) {
        [KTVHTTPCache proxyStop];
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
        NSLog(@"URL Filter reviced URL : %@", URL);
        return URL;
    }];
    [KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
        NSLog(@"Unsupport Content-Type Filter reviced URL : %@, %@", URL, contentType);
        return NO;
    }];
    
    
    // Do any additional setup after loading the view.
    NSArray *videoUrls = @[
                           @"http://jmdianbostag.ks3-cn-beijing.ksyun.com/MjQ0NzY5NDU2/MTUxNjY5NzAzNTgwNg_E_E/OTQ2NTc2MA_E_E/MDY2OTVDOUItMzYwNi00MUM1LUJFRUQtRjJCQkJGOThFOTIyLk1PVg_E_E_default.mp4",
                           @"http://jmdianbostag.ks3-cn-beijing.ksyun.com/MTE1NzIzNzAz/MTUxNjUzNzA4MDk4Nw_E_E/MTAyNzE1NDM_E/dHJpbS4wN0JDOTEzMy01M0VELTQ5OUQtOTY2RS1GNUM4NDZEMUY5OTAuTU9W_default.mp4",
                           //                           @"http://jin10videoserver.jin10.com/Act-ss-mp4-hd/003a64edfa87489fb1bd38e39a0cdb20/20190611zzd.mp4",
                           @"http://jmvideo1.jumei.com/MQ_E_E/MTUxOTY0MTkwMDA3MA_E_E/NDA0NDkzNA_E_E/L2hvbWUvd3d3L2xvZ3MvdmlkZW8vZmlsZV84OTkyMTMtOTg3N2Y3ZTM2YTYzN2I2ZjY2OTE0ZGU1YjIxNDFkZDQvdmlkZW8ubXA0.mp4",
                           
                           @"https://cdn-news.jin10.com/9a8a3cdf-ff49-4fd6-8012-af6e69acf287.mp4",
                           
                           @"https://cdn-news.jin10.com/ee863e24-99fa-4a04-9320-3c9e294be466.mp4",
                           
                           @"https://cdn-news.jin10.com/be975300-74f7-4bda-b236-62a9275166a7.mp4",
                           
                           @"https://cdn-news.jin10.com/a894c8c5-86ad-4125-84c2-398b321ef009.mp4",
                           
                           @"https://cdn-news.jin10.com/2f6d1b06-503a-44ba-9a30-33a58e00faec.mp4",
                           
                           @"https://cdn-news.jin10.com/e4845082-f8d1-4066-b624-f98847273776.mp4",
                           
                           @"https://cdn-news.jin10.com/1159d8d1-db33-45b1-94f6-c986a674d2ac.mp4",
                           
                           @"https://cdn-news.jin10.com/fc0f6f4a-7160-4e0e-8090-a095cce33e34.mp4",
                           
                           @"https://cdn-news.jin10.com/a770fae5-4b0b-4f23-926a-64ecb820a6d1.mp4",
                           
                           @"https://cdn-news.jin10.com/2b60bbc1-9a52-42e0-9c25-9bea444678a7.mp4",
                           
                           
                           ];
    
    _videoUrls = videoUrls;
    [self.view addSubview:self.mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoUrls.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShortVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShortVideoTableViewCell class])];
    NSURL *URL = [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:_videoUrls[indexPath.row]]];
    [cell setVideoURLString:URL.absoluteString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [((ShortVideoTableViewCell*)cell) stop];
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = self.view.backgroundColor;
        _mainTableView.pagingEnabled = YES;
        [_mainTableView registerClass:[ShortVideoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ShortVideoTableViewCell class])];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0;
            _mainTableView.estimatedSectionFooterHeight = 0;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _mainTableView;
}


@end
