//
//  DataCollectionViewCell.h
//  CollectionViewDragDemo
//
//  Created by Sylar on 2019/5/13.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@class DataCollectionViewCell;
@protocol DataCollectionViewCellDelegate <NSObject>

-(void)dataCollectionViewCellDelegate:(DataCollectionViewCell*)cell DidClickDeleteBtnWithModel:(DataModel*)model;

-(void)dataCollectionViewCellDelegate:(DataCollectionViewCell*)cell DidClickAddBtnWithModel:(DataModel*)model;

@end

@interface DataCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)DataModel *model;

//Add && Delete
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UIImageView *deleteIconImageView;
@property(nonatomic,strong)UIImageView *addIconImageView;


-(void)setDeleteBtnHide:(BOOL)isHide;
-(void)setAddBtnBtnHide:(BOOL)isHide;

@property(nonatomic,weak)id <DataCollectionViewCellDelegate> delegate;

@end


