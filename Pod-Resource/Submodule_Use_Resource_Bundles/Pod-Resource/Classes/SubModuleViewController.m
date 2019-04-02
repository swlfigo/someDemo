//
//  SubModuleViewController.m
//  Pods
//
//  Created by Sylar on 2019/4/1.
//

#import "SubModuleViewController.h"

@interface SubModuleViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation SubModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
    
    //需要硬编码模式读取
//    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingString:@"/Pod-Resource.bundle"];
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingString:@"/Pod-Resource2.bundle"];
    
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:@"secondLoading" inBundle:resource_bundle compatibleWithTraitCollection:nil];
    self.imageView.image = image;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.imageView.frame = self.view.bounds;
    
}




@end
