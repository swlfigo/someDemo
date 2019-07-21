//
//  ShortVideoPlayView.h
//  douyinDemo
//
//  Created by Sylar on 2019/7/21.
//  Copyright © 2019 Sylar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ShortVideoPlayView : UIView

@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *currentPlayerItem;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;

//设置播放路径
- (void)setPlayerWithUrl:(NSString *)url;

//取消播放
- (void)cancelLoading;
@end


