//
//  ShortVideoPlayView.m
//  douyinDemo
//
//  Created by Sylar on 2019/7/21.
//  Copyright © 2019 Sylar. All rights reserved.
//

#import "ShortVideoPlayView.h"

@implementation ShortVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    //禁止隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = self.layer.bounds;
    [CATransaction commit];
}

- (void)setPlayerWithUrl:(NSString *)url{
    _player = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
    _playerLayer.player = _player;
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _currentPlayerItem = _player.currentItem;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    [_player play];
}

- (void)cancelLoading{
    [_player pause];
    [_currentPlayerItem.asset cancelLoading];
    [_currentPlayerItem cancelPendingSeeks];
    [_player cancelPendingPrerolls];
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer.player = nil;
    _currentPlayerItem = nil;
    _playerLayer = nil;
}

@end
