//
//  CollectionviewCustomDragGestureViewController.m
//  CollectionViewDragDemo
//
//  Created by Sylar on 2019/5/13.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "CollectionviewCustomDragGestureViewController.h"
#import "DataCollectionReusableView.h"
#import "DataModel.h"
#import "DataCollectionViewCell.h"
@interface CollectionviewCustomDragGestureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DataCollectionViewCellDelegate>{
    //被拖拽的item
    DataCollectionViewCell *_dragingItem;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
}
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)NSMutableArray<NSMutableArray*> *modelArray;
@property(nonatomic,strong)NSMutableArray<DataModel*> *firstSecionArray;
@property(nonatomic,strong)NSMutableArray<DataModel*> *secondSecionArray;
@property(nonatomic,strong)NSMutableArray<DataModel*> *thirdSecionArray;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)NSArray *reuseTitleArray;
@end

@implementation CollectionviewCustomDragGestureViewController
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
    
    _dragingItem = [[DataCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, 61, 63)];
    _dragingItem.hidden = true;
    [_mainCollectionView addSubview:_dragingItem];
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

    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            [self enterEditMode:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}


#pragma mark - Gesture
//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point{
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    [_mainCollectionView bringSubviewToFront:_dragingItem];
    DataCollectionViewCell *item = (DataCollectionViewCell*)[_mainCollectionView cellForItemAtIndexPath:_dragingIndexPath];
    //更新被拖拽的item
    _dragingItem.hidden = false;
    _dragingItem.frame = item.frame;
    //重新赋值新item
    _dragingItem.model = item.model;
    item.hidden = YES;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
}

//正在被拖拽、、、
-(void)dragChanged:(CGPoint)point{
    if (!_dragingIndexPath) {return;}
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rerangeCollectionViewDataSource];
        //更新item位置
        [_mainCollectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

-(void)rerangeCollectionViewDataSource{
    if (_dragingIndexPath.section == _targetIndexPath.section) {
        DataModel *model = _modelArray[_dragingIndexPath.section][_dragingIndexPath.row];
        [_modelArray[_dragingIndexPath.section] removeObjectAtIndex:_dragingIndexPath.row];
        [_modelArray[_dragingIndexPath.section] insertObject:model atIndex:_targetIndexPath.row];
        //因为不考虑跨区滑动，所以偷懒直接调换
        if (_dragingIndexPath.section == 0 && _targetIndexPath.section == 0) {
            
        }else if (_dragingIndexPath.section == 1 && _targetIndexPath.section == 1){
            
        }
    }
    
}


//拖拽结束
-(void)dragEnd{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_mainCollectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        _dragingItem.frame = endFrame;
    }completion:^(BOOL finished) {
        _dragingItem.hidden = true;
        DataCollectionViewCell *cell = (DataCollectionViewCell *)[_mainCollectionView cellForItemAtIndexPath:_dragingIndexPath];
        cell.hidden = NO;
    }];
}


#pragma mark - Assit Method
//获取被拖动IndexPath的方法
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *dragIndexPath = nil;
    //最后剩一个不可以排序
    NSIndexPath *indexPathTemp = [_mainCollectionView indexPathForItemAtPoint:point];
    if (indexPathTemp == nil) {
        //点击的地方不是Cell
        return dragIndexPath;
    }
    if ([_mainCollectionView numberOfItemsInSection:indexPathTemp.section] == 1 ) {
        return dragIndexPath;
    }
    for (NSIndexPath *indexPath in _mainCollectionView.indexPathsForVisibleItems) {
        //快捷入口不需要排序
        if (indexPath.section == 1) {continue;}
        //各个分区寻找点击点的Cell
        if (CGRectContainsPoint([_mainCollectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            dragIndexPath = indexPath;
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _mainCollectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        //第二组不需要排序
        if (indexPath.section == 1) {continue;}
        //同一分区才可以排序
        if (indexPath.section == _dragingIndexPath.section) {
            //在第一组中找出将被替换位置的Item
            if (CGRectContainsPoint([_mainCollectionView cellForItemAtIndexPath:indexPath].frame, point)) {
                targetIndexPath = indexPath;
            }
        }
        
    }
    return targetIndexPath;
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
