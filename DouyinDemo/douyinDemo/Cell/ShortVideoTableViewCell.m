//
//  ShortVideoTableViewCell.m
//  douyinDemo
//
//  Created by Sylar on 2019/7/21.
//  Copyright © 2019 Sylar. All rights reserved.
//

#import "ShortVideoTableViewCell.h"
#import "ShortVideoPlayView.h"
@interface ShortVideoTableViewCell ()
@property(nonatomic,strong)ShortVideoPlayView *playerView;

@end

@implementation ShortVideoTableViewCell

- (void)prepareForReuse{
    [super prepareForReuse];
    [_playerView cancelLoading];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _playerView.frame = self.bounds;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _playerView = [[ShortVideoPlayView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_playerView];
    }
    return self;
}


- (void)setVideoURLString:(NSString *)urlString{
    [_playerView setPlayerWithUrl:urlString];
}

- (void)stop{
    [_playerView cancelLoading];
}
@end
