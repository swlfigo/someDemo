//
//  PodSubViewController.m
//  Pods
//
//  Created by Sylar on 2019/4/2.
//

#import "PodSubViewController.h"

@interface PodSubViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation PodSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
    
    //这种resource方法只需要self class 读取出bundle即可获得图片
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:@"arrow"
                                inBundle:bundle compatibleWithTraitCollection:nil];
    self.imageView.image = image;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.imageView.frame = self.view.bounds;
}

@end
