//
//  DataCollectionReusableView.m
//  CollectionViewDragDemo
//
//  Created by Sylar on 2019/5/13.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "DataCollectionReusableView.h"

@implementation DataCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _titleLabel = [[YYLabel alloc]initWithFrame:CGRectMake(20, 0, frame.size.width, frame.size.height)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self addSubview:_titleLabel];
    }
    return self;
}
@end
