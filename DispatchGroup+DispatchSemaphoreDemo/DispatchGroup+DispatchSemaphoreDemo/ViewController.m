//
//  ViewController.m
//  DispatchGroup+DispatchSemaphoreDemo
//
//  Created by Sylar on 2019/8/8.
//  Copyright © 2019 jin10. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view addSubview:self.mainTableView];
    
    //模拟有10个任务
    //最大并发量3
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    NSLog(@"准备开始任务");
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);

    dispatch_async(queue, ^{
        
        for (int i = 0 ; i < 10; ++i) {
            
            NSLog(@"开始任务 %d",i);
            dispatch_group_enter(group);
            [self networkRequestBlock:^{
                
                NSLog(@"完成任务 %d",i);
                
                dispatch_semaphore_signal(semaphore);
                dispatch_group_leave(group);
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        }
        
        NSLog(@"for End");
    });
    

    
    dispatch_group_notify(group, queue, ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        NSLog(@"所有任务完成");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"所有任务完成回到主线程");
        });
        
    });
    
    
}


-(void)networkRequestBlock:(void(^)(void))callBackBlock{
    //网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(5);
        if (callBackBlock) {
            callBackBlock();
        }
    });

}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - Getter
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _mainTableView;
}


@end
