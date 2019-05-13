//
//  DataCollectionViewCell.m
//  CollectionViewDragDemo
//
//  Created by Sylar on 2019/5/13.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "DataCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

@interface DataCollectionViewCell()

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)YYLabel *titleLabel;


@end


@implementation DataCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Icon
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 38, 38)];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.image = [UIImage imageNamed:@"icon"];
        _titleLabel = [YYLabel new];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_iconImageView.mas_right).with.offset(5.0f);
            make.left.mas_equalTo(_iconImageView.mas_left).with.offset(-5.0f);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(0.0f);
        }];
        
        _addIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LeftUserModule_addModule"]];
        _addIconImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 4.0f, 0, 14.0f, 14.0f);
        [self.contentView addSubview:_addIconImageView];
        _addIconImageView.hidden = YES;
        _deleteIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LeftUserModule_deleteModule"]];
        [self.contentView addSubview:_deleteIconImageView];
        _deleteIconImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 4.0f, 0, 14.0f, 14.0f);
        _deleteIconImageView.hidden = YES;
        
        _addBtn = [[UIButton alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_addBtn];
        _addBtn.hidden = YES;
        [_addBtn addTarget:self action:@selector(addBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _deleteBtn = [[UIButton alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_deleteBtn];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(deleteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setAddBtnBtnHide:(BOOL)isHide{
    _addBtn.hidden = _addIconImageView.hidden = isHide;
}

- (void)setDeleteBtnHide:(BOOL)isHide{
    _deleteIconImageView.hidden = _deleteBtn.hidden = isHide;
}



-(void)deleteBtnDidClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(dataCollectionViewCellDelegate:DidClickDeleteBtnWithModel:)]) {
        [self.delegate dataCollectionViewCellDelegate:self DidClickDeleteBtnWithModel:_model];
    }
}

-(void)addBtnDidClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(dataCollectionViewCellDelegate:DidClickAddBtnWithModel:)]) {
        [self.delegate dataCollectionViewCellDelegate:self DidClickAddBtnWithModel:_model];
    }
}


- (void)setModel:(DataModel *)model{
    _model = model;
    _titleLabel.text = model.moduleTitle;
}



@end
