//
//  CollectionviewSystemAPIViewController.m
//  CollectionViewDragDemo
//
//  Created by Sylar on 2019/5/13.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "CollectionviewSystemAPIViewController.h"
#import "DataCollectionReusableView.h"
#import "DataModel.h"
#import "DataCollectionViewCell.h"
@interface CollectionviewSystemAPIViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DataCollectionViewCellDelegate>
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)NSMutableArray<NSMutableArray*> *modelArray;
@property(nonatomic,strong)NSMutableArray<DataModel*> *firstSecionArray;
@property(nonatomic,strong)NSMutableArray<DataModel*> *secondSecionArray;
@property(nonatomic,strong)NSMutableArray<DataModel*> *thirdSecionArray;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)NSArray *reuseTitleArray;
@end

@implementation CollectionviewSystemAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    _modelArray = [[NSMutableArray alloc]init];
    _firstSecionArray = [[NSMutableArray alloc]init];
    _secondSecionArray = [[NSMutableArray alloc]init];
    _thirdSecionArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; ++i) {
        DataModel *model = [[DataModel alloc]init];
        model.moduleTitle = [NSString stringWithFormat:@"一%d",i];
        model.canBeDelete = YES;
        [_firstSecionArray addObject:model];
    }
    
    for (int j = 0; j < 3; ++j) {
        DataModel *model = [[DataModel alloc]init];
        model.moduleTitle = [NSString stringWithFormat:@"二%d",j];
        [_secondSecionArray addObject:model];
    }
    
    for (int k = 0; k < 4; ++k) {
        DataModel *model = [[DataModel alloc]init];
        model.moduleTitle = [NSString stringWithFormat:@"三%d",k];
        model.canBeDelete = YES;
        [_thirdSecionArray addObject:model];
    }
    
    [_modelArray addObject:_firstSecionArray];
    [_modelArray addObject:_secondSecionArray];
    [_modelArray addObject:_thirdSecionArray];
    
    _isEdit = NO;
    [self.view addSubview:self.mainCollectionView];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _reuseTitleArray = @[@"常用功能",@"所有功能",@"快捷入口"];
}

#pragma mark - CollectionView Delegate
//分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _modelArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _modelArray[section].count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //    if (_sourceDataArray[section].count == 0) {
    //        return CGSizeZero;
    //    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width,22);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    DataCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DataCollectionReusableView class]) forIndexPath:indexPath];
    
    if (!_isEdit) {
        headerView.titleLabel.text = _reuseTitleArray[indexPath.section];
    }else{
        if (indexPath.section == 1) {
            headerView.titleLabel.text = _reuseTitleArray[indexPath.section];
        }else{
            headerView.titleLabel.text = [NSString stringWithFormat:@"%@ (按住拖动调整排序)",_reuseTitleArray[indexPath.section]];
        }
    }
    
    
    
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DataCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    DataModel *model = _modelArray[indexPath.section][indexPath.row];
    cell.model = model;
    if (_isEdit) {
        if (model.canBeDelete) {
            //            cell.deleteBtn.hidden = NO;
            //            cell.addBtn.hidden = YES;
            [cell setDeleteBtnHide:NO];
            [cell setAddBtnBtnHide:YES];
        }else{
            //            cell.deleteBtn.hidden = YES;
            //            cell.addBtn.hidden = NO;
            [cell setDeleteBtnHide:YES];
            [cell setAddBtnBtnHide:NO];
        }
    }else{
        //        cell.deleteBtn.hidden = YES;
        //        cell.addBtn.hidden = YES;
        [cell setDeleteBtnHide:YES];
        [cell setAddBtnBtnHide:YES];
    }
    return cell;
}


#pragma mark - Gesture
- (void)longPress:(UIGestureRecognizer *)longPress {
    //获取点击在collectionView的坐标
    CGPoint point = [longPress locationInView:_mainCollectionView];
    //从长按开始
    //不使用系统API，无法达到要求效果
    NSIndexPath *indexPath=[_mainCollectionView indexPathForItemAtPoint:point];
    if (longPress.state == UIGestureRecognizerStateBegan) {
         if (@available(iOS 9.0, *)) {
             [_mainCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
             [self enterEditMode:YES];
         }

        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        if (@available(iOS 9.0, *)) {
            [_mainCollectionView updateInteractiveMovementTargetPosition:point];
        }
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        if (@available(iOS 9.0, *)) {
            [_mainCollectionView endInteractiveMovement];
        }

        //其他情况
    } else {
        if (@available(iOS 9.0, *)) {
            [_mainCollectionView cancelInteractiveMovement];
        }

    }

}

#pragma mark - On Edit
-(void)enterEditMode:(BOOL)isEditMode{
    _isEdit = isEditMode;
    if (_isEdit) {
        //进入编辑状态
        for (DataCollectionViewCell *cell in _mainCollectionView.visibleCells) {
            if (cell.model.canBeDelete) {
                //                cell.deleteBtn.hidden = NO;
                //                cell.addBtn.hidden = YES;
                [cell setDeleteBtnHide:NO];
                [cell setAddBtnBtnHide:YES];
            }else{
                //                cell.deleteBtn.hidden = YES;
                //                cell.addBtn.hidden = NO;
                [cell setDeleteBtnHide:YES];
                [cell setAddBtnBtnHide:NO];
            }
        }
        
        if (@available(iOS 9.0, *)) {
            for (NSIndexPath *indexPath in [_mainCollectionView indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader]){
                if (indexPath.section != 1) {
                    DataCollectionReusableView *reuseView = (DataCollectionReusableView *)[_mainCollectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                    reuseView.titleLabel.text = [NSString stringWithFormat:@"%@ (按住拖动调整排序)",_reuseTitleArray[indexPath.section]];
                }
                
                
            }
        }

    }else{
        for (DataCollectionViewCell *cell in _mainCollectionView.visibleCells) {
            [cell setDeleteBtnHide:YES];
            [cell setAddBtnBtnHide:YES];
        }

    }
}

#pragma mark - Cell Delegate

- (void)dataCollectionViewCellDelegate:(DataCollectionViewCell *)cell DidClickAddBtnWithModel:(DataModel *)model{
    NSIndexPath *oldIndexPath = [self.mainCollectionView indexPathForCell:cell];
    //修改为不可添加状态
    cell.model.canBeDelete = YES;
    [self.mainCollectionView reloadItemsAtIndexPaths:@[oldIndexPath]];
    
    DataModel *oldModel = _modelArray[1][oldIndexPath.row];
    [_modelArray[1]removeObject:oldModel];
    [_modelArray[0]addObject:oldModel];
    
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:[_modelArray[0] indexOfObject:_modelArray[0].lastObject] inSection:0];
    [self.mainCollectionView moveItemAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
    
}


- (void)dataCollectionViewCellDelegate:(DataCollectionViewCell *)cell DidClickDeleteBtnWithModel:(DataModel *)model{
    NSIndexPath *oldIndexPath = [self.mainCollectionView indexPathForCell:cell];
    //偷懒，使用 section 做判断依据，原项目用Type判断
    if (oldIndexPath.section == 0) {
        //Apps调整
        
        //修改为可添加状态
        cell.model.canBeDelete = NO;
        [self.mainCollectionView reloadItemsAtIndexPaths:@[oldIndexPath]];
        
        DataModel *oldModel = _modelArray[0][oldIndexPath.row];
        [_modelArray[0] removeObject:oldModel];
        [_modelArray[1] addObject:oldModel];
        
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:[_modelArray[1] indexOfObject:_modelArray[1].lastObject] inSection:1];
        [self.mainCollectionView moveItemAtIndexPath:oldIndexPath toIndexPath:newIndexPath];
        
    }else if (oldIndexPath.section == 2){
        //快捷访问调整
        DataModel *oldModel = _modelArray[2][oldIndexPath.row];
        [_modelArray[2] removeObject:oldModel];
        [_mainCollectionView deleteItemsAtIndexPaths:@[oldIndexPath]];
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //同一个Section才能交换，否则移动回去
    if (destinationIndexPath.section == sourceIndexPath.section) {
        [_modelArray[sourceIndexPath.section] exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
    }else{
        [self.mainCollectionView moveItemAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
    }
}

#pragma mark - Getter

- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        NSInteger itemWidth = 61;
        layout.itemSize = CGSizeMake(itemWidth, 63.0f);
        //4列
        layout.sectionInset = UIEdgeInsetsMake(16, 15, 16, 15);
        layout.minimumInteritemSpacing = floor(([UIScreen mainScreen].bounds.size.width - itemWidth * 4 - 15.0 ) / 3.0);
        layout.minimumLineSpacing = 16;
        layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 22);
        
        
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = self.view.backgroundColor;
        [_mainCollectionView registerClass:[DataCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DataCollectionViewCell class])];
        [_mainCollectionView registerClass:[DataCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DataCollectionReusableView class])];
        if (@available(iOS 11.0, *)) {
            //ipX
            _mainCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.2f;
        [_mainCollectionView addGestureRecognizer:longPress];
    }
    return _mainCollectionView;
}
@end
